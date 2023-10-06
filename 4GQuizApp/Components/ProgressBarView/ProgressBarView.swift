//
//  ProgressBarView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct ProgressBarView: View {
    @State var title: String = "Wczytuje..."
    @Binding var isLoading: Bool
    @State private var progressAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                ProgressView(title, value: progressAmount, total: 100)
                    .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .onReceive(timer) { _ in
                        if progressAmount < 100 {
                            progressAmount += 2
                    }
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(isLoading: .constant(true))
    }
}

struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color(red: 0, green: 0, blue: 0.6), radius: 4.0, x: 1.0, y: 2.0)
    }
}
