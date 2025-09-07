//
//  HTTPClient.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation

protocol HTTPClient {
    func perform<T: Decodable>(endPoint: EndPoint, responseModelType: T.Type) async throws -> T
}

final class HTTPClientImpl: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func perform<T: Decodable>(endPoint: EndPoint, responseModelType: T.Type) async throws -> T {
        guard let request = endPoint.getRequest else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    throw NetworkError.noInternetConnection
                case .timedOut:
                    throw NetworkError.timeout
                default:
                    throw NetworkError.networkError(error)
                }
            }
            throw NetworkError.networkError(error)
        }
    }
}
