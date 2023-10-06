//
//  RoundedButtonReusable.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct RoundedButtonReusable: View {
    var title: String
    var titleColor: Color = .white
    var foregroundColor: Color = .blue
    var fontSize: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(foregroundColor)
                    .frame(width: 110, height: 40)
                    .padding()
                    .padding(.horizontal)
                HStack {
                    Text(title)
                        .foregroundColor(titleColor)
                        .font(.system(size: fontSize, weight: .bold))
                }
            }
        })
    }
}

struct RoundedButtonReusable_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonReusable(title: "title",
                              fontSize: 12.0,
                              action: {})
    }
}
