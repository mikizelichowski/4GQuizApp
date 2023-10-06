//
//  APIError.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation

enum APIError: Error {
    case invalidUrl(message: String)
    case invalidResponse(message: String)
    case badRequest(message: String)
    case unexepctedStatusCode(message: String)
    case apiError(message: String)
    case unknown
}
