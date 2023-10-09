//
//  QuizDetailModel.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

struct QuizDetailModel: Codable {
    let opinions_enabled: Bool
    let rates: [Rate]
    let questions: [Question]
    let createdAt: String
    let sponsored: Bool
    let title: String
    let type: String
    let content: String
    let tags: [CategoryElement]
    let buttonStart: String
    let shareTitle: String
    let categories: [CategoryElement]
    let id: Int
    let scripts: String
    let mainPhoto: MainPhoto
    let category: CategoryModel
    let isBattle: Bool
    let created: Int
    let canonical: String
    let productUrl: String
    let publishedAt: String
    let latestResults: [LatestResult]
    let avgResult: Double
    let resultCount: Int
    let userBattleDone: Bool
    let sponsoredResults: SponsoredResults
}

// MARK: - CategoryElement
struct CategoryElement: Codable {
    let uid: Int
    let secondaryCid: String?
    let name: String
    let type: String
    let primary: Bool?
}

// MARK: - Category
struct CategoryModel: Codable {
    let id: Int
    let name: String
}

// MARK: - LatestResult
struct LatestResult: Codable {
    let city: Int
    let end_date: String
    let result: Double
    let resolveTime: Int
}

// MARK: - Question
struct Question: Codable {
    let image: QuestionImage
    let answers: [AnswerElement]
    let text: String
    let answer: String
    let type: String
    let order: Int
}

// MARK: - AnswerElement
struct AnswerElement: Codable {
    let image: QuestionImage
    let order: Int
    let text: String
    let isCorrect: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(QuestionImage.self, forKey: .image)
        self.order = try container.decode(Int.self, forKey: .order)
        self.isCorrect = try container.decodeIfPresent(Int.self, forKey: .isCorrect)
        
        do {
            self.text = try String(container.decode(Int.self, forKey: .text))
        } catch DecodingError.typeMismatch {
            self.text = try container.decode(String.self, forKey: .text)
        }
    }
}

// MARK: - QuestionImage
struct QuestionImage: Codable {
    let author: String
    let width: String?
    let mediaId: String
    let source: String
    let url: String
    let height: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.mediaId = try container.decode(String.self, forKey: .mediaId)
        self.source = try container.decode(String.self, forKey: .source)
        self.url = try container.decode(String.self, forKey: .url)
        do {
            self.height = try String(container.decode(Int.self, forKey: .height))
        } catch DecodingError.typeMismatch {
            self.height = try container.decode(String.self, forKey: .height)
        }

        do {
            self.width = try String(container.decode(Int.self, forKey: .width))
        } catch DecodingError.typeMismatch {
            self.width = try container.decode(String.self, forKey: .width)
        }
    }
}

// MARK: - Rate
struct Rate: Codable {
    let from: Int
    let to: Int
    let content: String
}

// MARK: - SponsoredResults
struct SponsoredResults: Codable {
    let imageAuthor: String
    let imageHeight: String
    let imageUrl: String
    let imageWidth: String
    let textColor: String
    let content: String
    let mainColor: String
    let imageSource: String
}
