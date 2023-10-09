//
//  QuestionListView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionListViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if viewModel.isShowAlertQuiz {
                CustomAlert(title: "Czy chcesz dokończyć ostatni quiz?", titleLeftButton: "Nowy", titleRightButton: "Kontynuuj", actionLeftButton: { viewModel.setNewQuiz() }, actionRightButton: { viewModel.setLastQuiz() })
            } else {
                ListQuizView(viewModel: viewModel)
            }
        }
        .refreshable {
            withAnimation {
                self.viewModel.animate.toggle()
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
                                       lastScore: viewModel.isContinueLastQuiz ? lastQuiz.points : 0,
                                       isContinueLastQuiz: $viewModel.isContinueLastQuiz)
                    }
                }
                else {
                    if let quiz = viewModel.quizDetailFromCache {
                        DetailQuizView(quiz: quiz,
                                       lastIndex: 0,
                                       lastScore: 0,
                                       isContinueLastQuiz: $viewModel.isContinueLastQuiz)
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
