//
//  QuizApiRepository.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

final class QuizApiRepository: QuizApiRepositoryProtocol {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getQuizList() async -> Result<Results, APIError> {
        return await self.networkManager.sendRequest(responseModel: Results.self,
                                                      url: APIConstants.baseURL)
    }
    
    func getDetailQuiz(quizId: Int) async -> Result <QuizDetailModel, APIError> {
        return await self.networkManager.sendRequest(responseModel: QuizDetailModel.self, url: "\(APIConstants.detailQuizURL)\(quizId)/0")
    }
}
