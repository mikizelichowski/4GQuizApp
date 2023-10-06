//
//  QuizApiRepositoryProtocol.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

protocol QuizApiRepositoryProtocol {
    func getQuizList() async -> Result<Welcome, APIError>
    func getDetailQuiz(quizId: Int) async -> Result <QuizDetailModel, APIError>
}
