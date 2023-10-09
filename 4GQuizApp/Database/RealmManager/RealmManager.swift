//
//  RealmManager.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 09/10/2023.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    func create<T: Object>(_ object: T)
}

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    static let shared = RealmManager()
    @Published private(set) var users: [User] = []
    
    init() {
        self.openRealm()
        self.getData()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
}

extension RealmManager: RealmManagerProtocol {
    func create<T: Object>(_ object: T) {
        do {
            guard let localRealm else { return }
            try localRealm.write {
                localRealm.add(object)
                self.getData()
                print("Save data")
            }
        } catch {
            print(error)
        }
    }
    
    func getData() {
        if let localRealm = localRealm {
            let allUsers = localRealm.objects(User.self)
            users = []
            allUsers.forEach({ user in
                users.append(user)
            })
        }
    }
}
