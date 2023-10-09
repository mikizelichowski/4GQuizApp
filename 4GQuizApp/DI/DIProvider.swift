//
//  DIProvider.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

struct DIProvider {
    static var cache: CacheProtocol {
        return Cache()
    }
    
    static var networkManager: NetworkManager {
        return NetworkManager(cache: cache)
    }
    
    static var quizCacheRepository: QuizCacheRepositoryProtocol {
        return QuizCacheRepository(cache: cache)
    }
    
    static var quizApiRepository: QuizApiRepositoryProtocol {
        return QuizApiRepository(networkManager: networkManager)
    }
    
    static var quizRepository: QuizRepositoryProtocol {
        return QuizRepository(apiService: quizApiRepository,
                              cache: quizCacheRepository)
    }
}
