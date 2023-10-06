//
//  CustomHeader.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

struct CustomHeader: View {
    var title: String
    var actionTapped: () -> ()
    
    var body: some View {
        HStack {
            Button {
                actionTapped()
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(title)
                .headerDetailTitle()
            Spacer()
        }
    }
}

struct CustomHeader_Previews: PreviewProvider {
    static var previews: some View {
        CustomHeader(title: "Title", actionTapped: {})
    }
}
