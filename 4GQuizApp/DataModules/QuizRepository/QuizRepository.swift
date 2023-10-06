//
//  QuizRepository.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

final class QuizRepository: QuizRepositoryProtocol {
    private let apiService: QuizApiRepositoryProtocol
    
    init(apiService: QuizApiRepositoryProtocol) {
        self.apiService = apiService
    }
    
    func getQuizList() async -> Result<Results, APIError> {
        return await apiService.getQuizList()
    }
    
    func getDetailQuiz(quizId: Int) async -> Result <QuizDetailModel, APIError> {
        return await apiService.getDetailQuiz(quizId: quizId)
    }
}
