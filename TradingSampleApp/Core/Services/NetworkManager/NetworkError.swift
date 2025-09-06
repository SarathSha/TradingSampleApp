//
//  NetworkError.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case timeout
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .noData:
            "No data received"
        case .decodingError(let error):
            "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            "Network error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            "Server error with status code: \(statusCode)"
        case .timeout:
            "Request timed out"
        case .noInternetConnection:
            "No internet connection"
        }
    }
}
