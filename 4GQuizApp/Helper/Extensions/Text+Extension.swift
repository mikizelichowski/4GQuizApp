//
//  Text+Extension.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

extension Text {
    func headerTitle() -> some View {
        self.font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
    }
    
    func subTitle() -> some View {
        self.font(.system(size: 18, weight: .regular))
            .fontWeight(.medium)
            .foregroundColor(.white)
    }
    
    func headerDetailTitle() -> some View {
        self.font(.system(size: 12, weight: .bold))
            .fontWeight(.medium)
            .foregroundColor(.royal)
    }
    
    func smallTitle() -> some View {
        self.font(.system(size: 9, weight: .bold))
            .fontWeight(.medium)
            .foregroundColor(.royal)
    }
}
