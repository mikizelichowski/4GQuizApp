//
//  InternetManager.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import SwiftUI
import Network

class InternetManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetManager")
    @Published var isConnected = true
    
    var imageName: String {
        return isConnected ? "wifi" : "wifi.slash"
    }
    
    var connectionDescription: String {
        if isConnected {
            return "Internet connection looks good!"
        } else {
            return "It looks like you're not connected to the internet"
        }
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
