//
//  DetailQuizView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct DetailQuizView: View {
    @StateObject var viewModel = DetailQuizViewModel()
    @Environment(\.dismiss) private var dismissView
    @State private var showScoreCardView: Bool = false
    @State private var showPopupInfo: Bool = false
    @State private var presentCloseAlert: Bool = false
    @State private var presentScoreAlert: Bool = true
    
    var quiz: QuizDetailModel
    var lastIndex: Int
    var lastScore: Int
    @Binding var isContinueLastQuiz: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.9)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    /// Header
                    CustomHeader(title: quiz.title, actionTapped: { self.presentCloseAlert.toggle() })
                    ///Progress Bar
                    ProgressBar(progress: viewModel.progressBarValue)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Wynik: \(viewModel.score)")
                                        .subTitle()
                                    Spacer()
                                    
                                    Image("4G")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .ignoresSafeArea()
                                        .frame(width: 20, height: 20)
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            self.showPopupInfo.toggle()
                                        }
                                    } label: {
                                        Text("Więcej")
                                            .subTitle()
                                    }
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple)
                                    }
                                }
                                .padding(.top)
                                
                                GeometryReader {_ in
                                    ForEach(quiz.questions.indices, id:\.self) { index in
                                        if self.viewModel.currentIndex == index {
                                            QuestionView(quiz.questions[viewModel.currentIndex])
                                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                        }
                                    }
                                    .onAppear {
                                        self.viewModel.currentIndex = lastIndex
                                        self.viewModel.score = lastScore
                                        self.viewModel.progressBarValue = CGFloat(viewModel.currentIndex) / CGFloat(quiz.questions.count - 1) * 350
                                    }
                                }
                                .padding(.horizontal,-15)
                                .padding(.vertical,15)
                            }
                        }
                        .hLeading()
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity)
                .vTop()
                .padding(.vertical)
                .padding(.horizontal)
                
                ReusableButton(title: viewModel.currentIndex == (quiz.questions.count - 1) ? "Koniec" : "Następne pytanie",
                               backgroundColor: viewModel.isSelectedAnswer == "" ? .gray.opacity(0.3) : .royal) {
                    if viewModel.currentIndex == (quiz.questions.count - 1) {
                        /// Presenting  Score Card
                        self.showScoreCardView.toggle()
                    } else {
                        withAnimation(.easeInOut){
                            self.viewModel.currentIndex += 1
                            /// Set value on progress bar
                            viewModel.progressBarValue =  CGFloat(viewModel.currentIndex) / CGFloat(quiz.questions.count - 1) * 350
                            /// Add point if answer is correct
                            self.viewModel.addScoreResult(answer: viewModel.answer)
                            /// Save to cache
                            self.viewModel.saveCurrentQuizToCache(value: LastQuiz(points: viewModel.score,
                                                                                  isCompleted: viewModel.currentIndex == (quiz.questions.count - 1),
                                                                                  order: viewModel.currentIndex,
                                                                                  quiz: quiz))
                        }
                    }
                }
                               .disabled(viewModel.isSelectedAnswer != "" ? false : true)
                               .vBottom()
            }
            .fullScreenCover(isPresented: $presentCloseAlert) {
                ZStack {
                    LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.9)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    
                    CustomAlert(title: "Czy jesteś pewny, że chcesz zakończyć quiz?", titleLeftButton: "Tak", titleRightButton: "Nie", actionLeftButton: {
                        self.dismissView()
                        self.isContinueLastQuiz = false
                        self.viewModel.cleanCurrentQuizFromCache()
                        self.presentCloseAlert.toggle()
                    }, actionRightButton: {
                        presentCloseAlert.toggle()
                    })
                }
            }
            .environment(\.colorScheme, .dark)
            .fullScreenCover(isPresented: $showScoreCardView) {
                let percent = CGFloat(viewModel.score) / CGFloat(quiz.questions.count) * 100
                ScoreCardView(isPresentPopupResult: $presentScoreAlert,
                              scoreMessage: viewModel.setMessage(rates: quiz.rates, score: percent)
                              ,score: percent, onTappedRepeatQuiz: {
                    self.isContinueLastQuiz = false
                    self.viewModel.cleanCurrentQuizFromCache()
                    self.viewModel.currentIndex = 0
                    self.viewModel.score = 0
                    self.viewModel.progressBarValue = 0.0
                }) {
                    withAnimation {
                        dismissView()
                        self.isContinueLastQuiz = false
                        self.viewModel.cleanCurrentQuizFromCache()
                    }
                }
            }
            .fullScreenCover(isPresented: $showPopupInfo, content: {
                ZStack {
                    InfoView(title: quiz.title,
                             description: quiz.content) {
                        withAnimation {
                            showPopupInfo = false
                        }
                    }
                }
                .vCenter()
                .hCenter()
            })
        }
    }
}
