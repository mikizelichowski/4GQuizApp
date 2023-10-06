//
//  QuizCardView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct QuizCardView: View {
    var quiz: Quiz
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(quiz.title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.royal)
                        .hLeading()
                    
                   
                    HStack(spacing: 0) {
                        ForEach(quiz.tags, id:\.uid) { tag in
                            Text("#\(tag.name)")
                               
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
            }
        }
    }
}
