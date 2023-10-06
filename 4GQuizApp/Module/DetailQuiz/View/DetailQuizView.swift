//
//  DetailQuizView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct DetailQuizView: View {
    @StateObject private var viewModel = DetailQuizViewModel()
    @Environment(\.dismiss) private var dismissView
    @State private var showScoreCardView: Bool = false
    @State private var showPopupInfo: Bool = false
    @State private var startQuizAgain: Bool = false
    
    var quiz: QuizDetailModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightBlueGreyThree
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    /// Header
                    CustomHeader(title: quiz.title, actionTapped:{ dismissView()})
                    ///Progress Bar
                    ProgressBar(progress: viewModel.progressBarValue)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                HStack {
                                Text("Wynik: \(viewModel.score)")
                                        .subTitle()
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
                                            .fill(Color.royal.opacity(0.3))
                                    }
                                }
                                
                                GeometryReader {_ in
                                    ForEach(quiz.questions.indices, id:\.self) { index in
                                        if viewModel.currentIndex == index {
                                            QuestionView(quiz.questions[viewModel.currentIndex])
                                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                        }
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
                            viewModel.currentIndex += 1
                            /// Set value on progress bar
                            viewModel.progressBarValue =  CGFloat(viewModel.currentIndex) / CGFloat(quiz.questions.count - 1) * 350
                            /// Add point if answer is correct
                            self.viewModel.addScoreResult(answer: viewModel.answer)
                        }
                    }
                }
                .disabled(viewModel.isSelectedAnswer != "" ? false : true)
                .vBottom()
            }
            .environment(\.colorScheme, .dark)
            .fullScreenCover(isPresented: $showScoreCardView) {
                let percent = CGFloat(viewModel.score) / CGFloat(quiz.questions.count) * 100
                // add score view
            }
            .fullScreenCover(isPresented: $showPopupInfo, content: {
                ZStack {
                    Color.aquaMarine
                        .opacity(0.3)
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
    
    @ViewBuilder
    func QuestionView(_ question: Question)-> some View {
        VStack(alignment: .leading, spacing: 5) {
            if !(question.image.width?.isEmpty ?? false) {
                CustomImageHelper(imagekey: ImageHelper.shared.getPath(width: Int(question.image.width ?? "") ?? 0,
                                                                       height: Int(question.image.height ?? "") ?? 0,
                                                                       urlName: question.image.url))
                    .frame(height: 200)
                    .cornerRadius(12, corners: .allCorners)
            }
            
            Text("Pytania: \(viewModel.currentIndex + 1)/\(quiz.questions.count)")
                .font(.callout)
                .foregroundColor(.gray)
                .hLeading()
            
            Text(question.text)
                .headerDetailTitle()
                .frame(height: CGFloat(question.text.count))
                .lineLimit(5)
            
            VStack(spacing: 12) {
                ForEach(question.answers,id:\.order) { option in
                    ZStack {
                        AnswerView(option.text, tint: .gray)
                            .opacity(viewModel.isSelectedAnswer == option.text && viewModel.isSelectedAnswer != "" ? 0 : 1)
                        AnswerView(option.text, tint: .royal)
                            .opacity(viewModel.isSelectedAnswer == option.text && viewModel.isSelectedAnswer != "" ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.viewModel.isSelectedAnswer = option.text
                        self.viewModel.answer = option
                    }
                }
            }
            .padding(.vertical,10)
        }
        .padding(15)
        .hCenter()
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
        }
        .padding(.horizontal,15)
    }
    
    @ViewBuilder
    func AnswerView(_ answer: String, tint: Color)-> some View {
        Text(answer)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(tint)
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .lineLimit(2)
            .frame(height: 50)
            .hLeading()
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.15))
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(tint.opacity(tint == .gray ? 0.15 : 1), lineWidth: 2)
                    }
            }
    }
}
