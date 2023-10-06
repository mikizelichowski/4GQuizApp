//
//  NetworkManager.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import Foundation
import UIKit
import Combine

protocol NetworkManagerProtocol {
    /// Async/await option
    func sendRequest<T: Codable>(responseModel: T.Type, url: String) async -> Result<T, APIError>
    /// Combine option
    func sendRequestCombine<T: Codable>(responseModel: T.Type, url: String) -> AnyPublisher<T, Error>
    func getImage(imgUrl: String) async throws -> UIImage?
}

final class NetworkManager: NetworkManagerProtocol {
    init() {}
    
    // MARK: Async Await option
    func sendRequest<T: Codable>(responseModel: T.Type, url: String) async -> Result<T, APIError> {
        guard let url = URL(string: url) else {
            return .failure(.invalidUrl(message: "Invalid url"))
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse(message: "Invalid response"))
            }
            
            switch response.statusCode {
            case 200...299:
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                print("DEBUG: decode\(decodeData)")
                return .success(decodeData)
            case 400:
                return .failure(.badRequest(message: "Bad request"))
            case 404:
                return .failure(.apiError(message: "Resource not found"))
            case 422:
                return .failure(.apiError(message: "Client Error"))
            case 500...600:
                return .failure(.apiError(message: "Server error"))
            default:
                return .failure(.unexepctedStatusCode(message: "\(response.statusCode)"))
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    // MARK: Combine option - if you can use
    func sendRequestCombine<T: Codable>(responseModel: T.Type, url: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            fatalError("\(APIError.invalidUrl(message: "Invalid Url"))")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response -> Data in
                guard let response = response as? HTTPURLResponse else { throw APIError.invalidResponse(message: "Invalid Response") }
          
                if response.statusCode == 400 {
                    throw APIError.badRequest(message: "Bad Request")
                }
                print("DEBUG: data \(data)")
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({$0.localizedDescription as! Error})
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

extension NetworkManager {
    private func handleReponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func getImage(imgUrl: String) async throws -> UIImage? {
        guard let url = URL(string: "\(imgUrl)") else {
            fatalError("Invalid url download image")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleReponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}
