//
//  CustomAlert.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI

struct CustomAlert: View {
    var title: String
    var titleLeftButton: String
    var titleRightButton: String
    var actionLeftButton: () -> ()
    var actionRightButton: () -> ()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 25){
                Image("4G")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                
                Text(title)
                
                HStack {
                    Button(action: {
                        withAnimation {
                            actionLeftButton()
                        }
                    }, label: {
                        Text(titleLeftButton)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    })
                    
                    Button(action: {
                        withAnimation {
                            actionRightButton()
                        }
                    }, label: {
                        Text(titleRightButton)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.purple)
                            .clipShape(Capsule())
                    })
                }
            
                
            }
            .padding(.vertical,25)
            .padding(.horizontal,30)
            .background(Color.white.opacity(1.0))
            .cornerRadius(25, corners: .allCorners)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35)
        )
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(title: "title", titleLeftButton: "left", titleRightButton: "right", actionLeftButton: {}, actionRightButton: {})
    }
}
