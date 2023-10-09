//
//  ContentView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var internetManager = InternetManager()
    @State private var presentMainView: Bool = false
    
    var body: some View {
        Group {
            if internetManager.isConnected {
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
                        QuestionListView()
                    }
                }
            } else {
                InternetView(internetManager: internetManager)
            }
        }
    }
}
