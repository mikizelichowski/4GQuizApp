//
//  DIProvider.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

struct DIProvider {
    static var networkManager: NetworkManager {
        return NetworkManager()
    }
    
    static var quizApiRepository: QuizApiRepositoryProtocol {
        return QuizApiRepository(networkManager: networkManager)
    }
    
    static var quizRepository: QuizRepositoryProtocol {
        return QuizRepository(apiService: quizApiRepository)
    }
}
