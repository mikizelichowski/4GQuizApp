//
//  DetailQuizViewModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation
import SwiftUI

final class DetailQuizViewModel: ObservableObject {
    @Published var answer: AnswerElement?
    @Published var isSelectedAnswer: String = ""
    @Published private(set) var score: Int = 0
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
}

