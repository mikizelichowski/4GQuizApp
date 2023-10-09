//
//  LastQuiz.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import Foundation

struct LastQuiz: Codable {
    let points: Int
    let isCompleted: Bool
    let order: Int
    let quiz: QuizDetailModel
}
