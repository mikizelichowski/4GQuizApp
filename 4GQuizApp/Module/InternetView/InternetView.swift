//
//  InternetView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

struct InternetView: View {
    @ObservedObject var internetManager: InternetManager
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: internetManager.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                
                Text(internetManager.connectionDescription)
                    .font(.system(size: 18))
                    .foregroundColor(.purple)
                    .padding()
                
                if !internetManager.isConnected {
                    Button {
                        withAnimation {
                            internetManager.isConnected.toggle()
                        }
                    } label: {
                        Text("Spróbuj ponownie")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .frame(width: 240)
                    .background(.purple)
                    .clipShape(Capsule())
                    .padding()
                }
            }
        }
    }
}
