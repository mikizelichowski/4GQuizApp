//
//  QuestionView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

extension DetailQuizView {
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
            
            Text("Pytania: \((viewModel.currentIndex) + 1)/\(quiz.questions.count)")
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
}
