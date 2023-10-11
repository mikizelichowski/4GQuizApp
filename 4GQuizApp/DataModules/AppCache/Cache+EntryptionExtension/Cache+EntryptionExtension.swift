//
//  Cache+EntryptionExtension.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 11/10/2023.
//

import Foundation
import CryptoKit
import UIKit

extension Cache {
    func encrypt(text: String, symmetricKey: SymmetricKey) throws -> String {
        let textData = text.data(using: .utf8)!
        let encrypted = try AES.GCM.seal(textData, using: symmetricKey)
        return encrypted.combined!.base64EncodedString()
    }
    
    func decrypt(text: String, symmetricKey: SymmetricKey) -> String {

         do {
             guard let data = Data(base64Encoded: text) else {
                 return "Could not decode text: \(text)"
             }

             let sealedBox = try AES.GCM.SealedBox(combined: data)
             let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)

             guard let text = String(data: decryptedData, encoding: .utf8) else {
                 return "Could not decode data: \(decryptedData)"
             }

             return text
         } catch let error {
             return "Error decrypting message: \(error.localizedDescription)"
         }
     }
    
    func saveKeyToKeychain(key: String, account: String) {
        let kcw = Keychain()
        do {
            try kcw.storeKeyFor(account: account, service: "cacheKey", key: key)
        } catch let error as KeychainWrapperError {
            print("Exception setting password: \(String(describing: error.message)) ?? no message")
        } catch {
            print("An error occurred setting the password.")
        }
    }
    
    func getKeyFromKeychain(account: String) -> String{
        let kcw = Keychain()
        if let key = try? kcw.getKeyFor(
            account: account,
            service: "cacheKey") {
            return key
        }
        return ""
    }
}
