//
//  AppCache.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 08/10/2023.
//

import Foundation
import Combine

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

    init() {
        userDefaults = UserDefaults.standard
    }
    
    func get(key: CacheKey) -> AnyPublisher<String, CacheError> {
        guard
            let value = userDefaults.string(forKey: key.rawValue)
        else {
            return Fail.init(error: CacheError.failedToRetrieve(nil)).eraseToAnyPublisher()
        }
        return Just(value)
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
        userDefaults.setValue(value, forKey: key.rawValue)
        
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
