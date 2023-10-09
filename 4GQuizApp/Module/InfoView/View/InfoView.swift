//
//  InfoView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct InfoView: View {
    var title: String
    var description: String
    var actionTapped: () -> ()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.9)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tytuł:")
                        .headerTitle()
                    Text(title)
                        .subTitle()
                        .padding(.horizontal)
                  
                
                    Text("Opis:")
                        .headerTitle()
                    Text(description)
                        .subTitle()
                        .padding(.horizontal)
                        
                }
                .hLeading()
                .vTop()
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                RoundedButtonReusable(title: "Zamknij",
                               fontSize: 14.0) {
                    actionTapped()
                }.frame(width: 110)
            }
        }
        .vCenter()
        .hCenter()
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(title: "title",
                 description: "description",
                 actionTapped: {})
    }
}
