//
//  Quiz.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

struct Results: Codable {
    let count: Int
    let items: [Quiz]
}

struct Quiz: Codable {
    let questions: Int
    let createdAt: String
    let sponsored: Bool
    let title: String
    let type: String
    let content: String
    let tags: [Tags]
    let buttonStart: String
    let shareTitle: String
    let categories: [Categories]
    let id: Int
    let mainPhoto: MainPhoto
    let category: Category
    let publishedAt: String
    let productUrls: ProductUrls
    let flagResults: [FlagResult]?
}

// MARK: - CategoryElement
struct Tags: Codable {
    let uid: Int
    let name: String
    let type: String
    let primary: Bool?
}

struct Categories: Codable {
    let uid: Int
    let secondaryCid: String
    let name: String
    let type: String
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

// MARK: - FlagResult
struct FlagResult: Codable {
    let image: Img
    let flag, title, content: String
}

// MARK: - Image
struct Img: Codable {
    let author, width, source, url: String
    let height: String
}

// MARK: - MainPhoto
struct MainPhoto: Codable {
    let author: String
    let width: Int
    let source: String
    let title: String
    let url: String
    let height: Int
}

// MARK: - ProductUrls
struct ProductUrls: Codable {
    let productUrls: String
    
    enum CodingKeys: String, CodingKey {
        case productUrls = "5888315728036481"
    }
}
