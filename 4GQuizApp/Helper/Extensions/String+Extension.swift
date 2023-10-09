//
//  String+Extension.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

extension String {
    public func prepareStringFromResponse(start: Int) -> String {
        let blobNameDropFirstTxt = self.dropFirst(start)
        return String(blobNameDropFirstTxt)
    }
}
