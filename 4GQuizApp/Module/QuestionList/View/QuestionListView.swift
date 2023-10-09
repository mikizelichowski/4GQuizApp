//
//  QuestionListView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionListViewModel()
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if viewModel.isShowAlertQuiz {
                CustomAlert(title: "Czy chcesz dokończyć ostatni quiz?", titleLeftButton: "Nowy", titleRightButton: "Kontynuuj", actionLeftButton: { viewModel.setNewQuiz() }, actionRightButton: { viewModel.setLastQuiz() })
            } else {
                VStack {
                    Image("4G")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .rotationEffect(Angle.degrees(animate ? 720 : 0))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(viewModel.isCacheIsEmpty ? viewModel.questions : viewModel.questionsFromCache, id: \.id) { value in
                            QuizCardView(quiz: value)
                                .frame(height: 340)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)
                                .onTapGesture {
                                    self.viewModel.isPresentDetailView.toggle()
                                    self.viewModel.getDetailQuiz(quizId: value.id)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical)
                } }
        }
        .refreshable {
            withAnimation {
                self.animate.toggle()
                viewModel.loadedData()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPresentDetailView, content: {
            ZStack {
                Color.lightBlueGreyThree.ignoresSafeArea()
                if viewModel.currentQuiz != nil {
                    if let quiz = viewModel.quizDetailFromCache,
                       let lastQuiz = viewModel.currentQuiz {
                        DetailQuizView(quiz: viewModel.isContinueLastQuiz ? lastQuiz.quiz : quiz,
                                       lastIndex: viewModel.isContinueLastQuiz ? lastQuiz.order : 0,
                                       lastScore: viewModel.isContinueLastQuiz ? lastQuiz.points : 0)
                    }
                }
                else {
                    if let quiz = viewModel.quizDetailFromCache {
                        DetailQuizView(quiz: quiz,
                                       lastIndex: 0,
                                       lastScore: 0)
                    }
                }
            }
        })
        .overlay {
            ProgressBarView(isLoading: $viewModel.isLoading)
        }
    }
}

struct QuestionListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListView()
    }
}
