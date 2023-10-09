//
//  AnswerView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

extension DetailQuizView {
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
