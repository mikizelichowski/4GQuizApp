//
//  ScoreCardViewModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

class ScoreCardViewModel: ObservableObject {
    @Published var realmManager = RealmManager.shared
    @Published var name: String = ""
    
    func saveRecord(score: CGFloat) {
        let user = User()
        user.name = name
        user.score = "\(String(format: "%.0f", score) + "%")"
        self.realmManager.create(user.self)
    }
}
