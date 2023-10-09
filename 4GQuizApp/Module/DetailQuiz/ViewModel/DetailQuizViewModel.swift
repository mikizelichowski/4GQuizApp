//
//  DetailQuizViewModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation
import SwiftUI
import Combine

final class DetailQuizViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var answer: AnswerElement?
    @Published var isSelectedAnswer: String = ""
    @Published var score: Int = 0
    @Published var currentIndex: Int = 0
    @Published var progressBarValue: CGFloat = 0.0
    
    func addScoreResult(answer: AnswerElement?) {
        if answer?.text == isSelectedAnswer {
            /// Remove selected answer
            self.isSelectedAnswer = ""
            if answer?.isCorrect != nil {
                score += 1
            }
        }
    }
    
    /// Result message
    func setMessage(rates: [Rate], score: CGFloat) -> String {
        var message = ""
        switch Int(score){
        case 0...20:
            message = rates.filter({$0.from == 0}).first?.content ?? ""
        case 20...40:
            message = rates.filter({$0.from == 20}).first?.content ?? ""
        case 40...60:
            message = rates.filter({$0.from == 40}).first?.content ?? ""
        case 60...80:
            message = rates.filter({$0.from == 60}).first?.content ?? ""
        case 80...100:
            message = rates.filter({$0.from == 80}).first?.content ?? ""
        default: return message
        }
        return message
    }
    
    func saveCurrentQuizToCache(value: LastQuiz) {
        DIProvider.quizCacheRepository.saveCurrentQuiz(key: .lastQuiz, value: value)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("DEBUG: SAVE_CURRENT_QUIZ_TO_CACHE 🔥")
                case .failure(let cacheError):
                    switch cacheError {
                    case .failedToSave:
                        print("DEBUG: Failed SAVE_CURRENT_QUIZ_TO_CACHE")
                    case .failedToRetrieve(let error):
                        print("DEBUG: Failed to retrieve  \(String(describing: error))")
                    }
                }
            }, receiveValue: { _ in }).store(in: &bag)
    }
}
