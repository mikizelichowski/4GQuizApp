//
//  ListQuizView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

struct ListQuizView: View {
    @ObservedObject var viewModel: QuestionListViewModel
    
    var body: some View {
        VStack {
            Image("4G")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .rotationEffect(Angle.degrees(viewModel.animate ? 720 : 0))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.isCacheIsEmpty ? viewModel.questions : viewModel.questionsFromCache, id: \.id) { value in
                        QuizCardView(quiz: value)
                            .frame(height: 340)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                            .onTapGesture {
                                self.viewModel.isPresentedDetailView.toggle()
                                self.viewModel.getDetailQuiz(quizId: value.id)
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}
