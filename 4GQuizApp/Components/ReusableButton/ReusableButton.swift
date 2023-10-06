//
//  ReusableButton.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ReusableButton: View {
    var title: String
    var backgroundColor: Color = .pink
    var action: () -> ()
    
    var body: some View {
        Button{
            action()
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .hCenter()
                .padding(.top, 15)
                .padding(.bottom, 15)
                .foregroundColor(.white)
                .background {
                    Rectangle()
                        .fill(backgroundColor)
                        .ignoresSafeArea()
                }
        }
        .padding([.bottom, .horizontal],-15)
    }
}
struct ReusableButton_Previews: PreviewProvider {
    static var previews: some View {
        ReusableButton(title: "title", action: {})
    }
}
