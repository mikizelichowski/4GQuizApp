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
    @State private var isPresentDetailView: Bool = false
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Image("4G")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .rotationEffect(Angle.degrees(animate ? 720 : 0))
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.questions, id: \.id) { value in
                        QuizCardView(quiz: value)
                            .frame(height: 340)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                            .onTapGesture {
                                self.isPresentDetailView.toggle()
                                self.viewModel.getDetailQuiz(quizId: value.id)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
        .refreshable {
            withAnimation {
                self.animate.toggle()
                viewModel.loadedData()
            }
            
        }
        .fullScreenCover(isPresented: $isPresentDetailView, content: {
            ZStack {
                Color.lightBlueGreyThree.ignoresSafeArea()
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
