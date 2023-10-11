//
//  AppCache.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 08/10/2023.
//

import Foundation
import Combine
import CryptoKit

enum CacheError: Error {
    case failedToSave
    case failedToRetrieve(_ data: String?)
}

protocol CacheProtocol {
    func get(key: CacheKey) -> AnyPublisher<String, CacheError>
    func save(key: CacheKey, value: String) -> AnyPublisher<Bool, CacheError>
    func remove(key: CacheKey) -> AnyPublisher<Bool, CacheError>
    func getObject<T: Decodable>(key: CacheKey) -> AnyPublisher<T, CacheError>
    func saveObject<T: Codable>(key: CacheKey, value: T) -> AnyPublisher<Bool, CacheError>
}

final class Cache: CacheProtocol {
    private var bag = Set<AnyCancellable>()
    private let userDefaults: UserDefaults
    enum Constants { static let keyLength = 32 }

    init() {
        userDefaults = UserDefaults.standard
    }
    
    func getSymmetricKey() -> SymmetricKey {
        let quizName = "quiz"
        var key = ""
        if self.getKeyFromKeychain(account: quizName).isEmpty {
                   key = String(String(NSUUID().uuidString.prefix(Constants.keyLength)))
                   self.saveKeyToKeychain(key: key, account: quizName)
               } else {
                   key = self.getKeyFromKeychain(account: quizName)
               }

               return SymmetricKey(data: key.data(using: .utf8)!)
    }
    
    
    // MARK: Cache
    func get(key: CacheKey) -> AnyPublisher<String, CacheError> {
        guard
            let value = userDefaults.string(forKey: key.rawValue),
            let decrypted = try? decrypt(text: value, symmetricKey: getSymmetricKey())
        else {
            return Fail.init(error: CacheError.failedToRetrieve(nil)).eraseToAnyPublisher()
        }
        return Just(decrypted)
            .setFailureType(to: CacheError.self)
            .eraseToAnyPublisher()
    }
    
    func remove(key: CacheKey) -> AnyPublisher<Bool, CacheError> {
        userDefaults.removeObject(forKey: key.rawValue)
        
        return Just(true)
            .setFailureType(to: CacheError.self)
            .eraseToAnyPublisher()
    }
    
    func save(key: CacheKey, value: String) -> AnyPublisher<Bool, CacheError> {
        guard let encrypted = try? encrypt(text: value, symmetricKey: getSymmetricKey()) else {
                    return Fail.init(error: CacheError.failedToSave).eraseToAnyPublisher()
                }
        
        userDefaults.setValue(encrypted, forKey: key.rawValue)
        
        return Just(true)
            .setFailureType(to: CacheError.self)
            .eraseToAnyPublisher()
    }
    
    func getObject<T: Decodable>(key: CacheKey) -> AnyPublisher<T, CacheError> {
        do {
            var data: String?
            self.get(key: key)
                .sink(receiveCompletion: {_ in },
                      receiveValue: { receiveData in
                    data = receiveData
                })
                .store(in: &bag)
            let decoder = JSONDecoder()
            guard let data = data else { return Fail.init(error: CacheError.failedToRetrieve(nil)).eraseToAnyPublisher() }

            let object = try decoder.decode(T.self, from: Data(data.utf8))
            return Just(object)
                .setFailureType(to: CacheError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail.init(error: CacheError.failedToRetrieve(nil)).eraseToAnyPublisher()
        }
    }
    
    func saveObject<T: Encodable>(key: CacheKey, value: T) -> AnyPublisher<Bool, CacheError> {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            return self.save(key: key, value: String(decoding: data, as: UTF8.self))
        } catch {
            return Fail.init(error: CacheError.failedToSave).eraseToAnyPublisher()
        }
    }
}
