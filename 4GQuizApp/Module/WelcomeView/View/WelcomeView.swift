//
//  WelcomeView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var presentNextView: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                ZStack {
                    Image("4G")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .vCenter()
                        .hCenter()
                }
            
                RoundedButtonReusable(title: "Zagraj",
                               foregroundColor: .purple,
                               fontSize: 24) {
                    presentNextView.toggle()
                }.hCenter()
                .padding(.bottom, 30)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(presentNextView: .constant(false))
    }
}
