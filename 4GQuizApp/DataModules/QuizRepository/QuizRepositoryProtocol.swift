//
//  QuizRepositoryProtocol.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

protocol QuizRepositoryProtocol {
    func getQuizList() async -> Result<Results, APIError>
    func getDetailQuiz(quizId: Int) async -> Result <QuizDetailModel, APIError>
}
