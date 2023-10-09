//
//  UserListView.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: ScoreCardViewModel
    @Binding var presentUsersList: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .blue.opacity(0.9)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                if viewModel.realmManager.users.isEmpty {
                    Text("Nie ma jeszczce nikogo")
                } else {
                    List {
                        ForEach(viewModel.realmManager.users,id:\.id) { user in
                            HStack {
                                Text(user.name)
                                Spacer()
                                Text(user.score)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                RoundedButtonReusable(title: "Zamknij",
                               fontSize: 14.0) {
                    self.presentUsersList.toggle()
                }.frame(width: 110)
            }
        }
        .hCenter()
        .vCenter()
    }
}
