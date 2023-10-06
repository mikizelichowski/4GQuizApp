//
//  ContentView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var presentMainView: Bool = false
    var body: some View {
        ZStack {
            ZStack {
                WelcomeView(presentNextView: $presentMainView)
                    .hCenter()
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $presentMainView) {
            ZStack {
                Color.softBlue
                    .ignoresSafeArea()
              //  QuestionListView()
            }
        }
    }
}
