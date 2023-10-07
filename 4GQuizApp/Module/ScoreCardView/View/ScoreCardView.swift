//
//  ScoreCardView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ScoreCardView: View {
    @Environment(\.dismiss) private var dismissView
    var scoreMessage: String
    var score: CGFloat
    @Binding var repeatQuiz: Bool
    var onTappedDismiss: () -> ()
    
    var body: some View {
        VStack{
            VStack(spacing: 15){
                Text("Wynik")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    Text("Gratulacje! \n\(scoreMessage)\n masz wynik")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(String(format: "%.0f", score) + "%")
                        .font(.title.bold())
                        .padding(.bottom,10)
                    
                    Image("done_order")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                }
                .foregroundColor(.black)
                .padding(.horizontal,15)
                .padding(.vertical,20)
                .vCenter()
                .background {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white)
                        .frame(height: 400)
                }
            }
            .vCenter()
            
            VStack {
                VStack(spacing: 10) {
                    ReusableButton(title: "Spróbuj jeszcze raz") {
                        dismissView()
                        repeatQuiz.toggle()
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                    
                    ReusableButton(title: "Wróć do głównego widoku") {
                        onTappedDismiss()
                        dismissView()
                    }
                    .padding(.vertical,20)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
        .padding(.top)
        .background {
            Color.royal
                .ignoresSafeArea()
        }
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCardView(scoreMessage: "", score: 3, repeatQuiz: .constant(false), onTappedDismiss: {})
    }
}
