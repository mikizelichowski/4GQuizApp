//
//  QuizCacheRepositoryProtocol.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 08/10/2023.
//

import Foundation
import Combine

protocol QuizCacheRepositoryProtocol: AnyObject {
    /// Quizzes
    func saveQuizzesToCache(key: CacheKey, value: [Quiz]) -> AnyPublisher<Bool, CacheError>
    func getQuizzesFromCache(key: CacheKey) -> AnyPublisher<[Quiz], CacheError>
    func clearCache(key: CacheKey)
    
    /// Quiz detail
    func saveQuizDetail(key: CacheKey, value: QuizDetailModel) -> AnyPublisher<Bool, CacheError>
    func getQuizDetail(key: CacheKey) -> AnyPublisher<QuizDetailModel, CacheError>
}
