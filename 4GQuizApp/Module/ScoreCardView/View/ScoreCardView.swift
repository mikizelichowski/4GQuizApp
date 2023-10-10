//
//  ScoreCardView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ScoreCardView: View {
    @StateObject private var viewModel = ScoreCardViewModel()
    @Environment(\.dismiss) private var dismissView
    @Binding var isPresentPopupResult: Bool
    var scoreMessage: String
    var score: CGFloat
    var onTappedRepeatQuiz: () -> ()
    var onTappedDismiss: () -> ()
    @State private var presentUsersList: Bool = false
    
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
                        onTappedRepeatQuiz()
                        dismissView()
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
                
                Button(action: {
                    self.presentUsersList.toggle()
                }, label: {
                    Text("Pokaż listę użytkowników")
                        .foregroundColor(.white)
                        .font(.system(size: 14.0, weight: .bold))
                })
            }
            .padding(.bottom, 20)
        }
        .fullScreenCover(isPresented: $presentUsersList, content: {
            UserListView(viewModel: viewModel, presentUsersList: $presentUsersList)
        })
        .fullScreenCover(isPresented: $isPresentPopupResult, content: {
            AddResultUserView(viewModel: viewModel, isPresentPopupResult: $isPresentPopupResult, score: score)
        })
        .padding(.top)
        .background {
            Color.royal
                .ignoresSafeArea()
        }
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCardView(isPresentPopupResult: .constant(false), scoreMessage: "", score: 3, onTappedRepeatQuiz: {}, onTappedDismiss: {})
    }
}
