//
//  AddResultUserView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

struct AddResultUserView: View {
    @ObservedObject var viewModel: ScoreCardViewModel
    @Binding var isPresentPopupResult: Bool
    var score: CGFloat
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.9)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
           
                Form {
                    TextField("Podaj imię", text: $viewModel.name)
                    Text("Twój wynik: \(String(format: "%.0f", score) + "%")")
                }
            
            RoundedButtonReusable(title: "Zapisz",
                           fontSize: 14.0) {
                if !viewModel.name.isEmpty {
                    viewModel.saveRecord(score: score)
                    isPresentPopupResult.toggle()
                }
            }
            .frame(width: 110)
            .hCenter()
        }
    }
}
