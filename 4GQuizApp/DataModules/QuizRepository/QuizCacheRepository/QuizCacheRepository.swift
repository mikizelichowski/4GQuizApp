//
//  QuizCacheRepository.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 08/10/2023.
//

import Foundation
import Combine

final class QuizCacheRepository: QuizCacheRepositoryProtocol {
    var cache: CacheProtocol
    private var bag = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    init(cache: CacheProtocol) {
        self.cache = cache
    }
    
    /// Quizzes
    func saveQuizzesToCache(key: CacheKey, value: [Quiz]) -> AnyPublisher<Bool, CacheError> {
        self.cache.saveObject(key: key, value: value)
    }
    
    func getQuizzesFromCache(key: CacheKey) -> AnyPublisher<[Quiz], CacheError> {
        self.cache.getObject(key: key)
    }
    
    func clearCache(key: CacheKey) {
        _ = self.cache.remove(key: key)
    }
    
    /// Quiz Detail
    func saveQuizDetail(key: CacheKey, value: QuizDetailModel) -> AnyPublisher<Bool, CacheError> {
        self.cache.saveObject(key: key, value: value)
    }
    
    func getQuizDetail(key: CacheKey) -> AnyPublisher<QuizDetailModel, CacheError> {
        self.cache.getObject(key: key)
    }
}
