//
//  Endpoint.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation

protocol EndPoint {
    var url: URL? { get }
    var method: String { get }
    var header: [String: String] { get }
    var body: [String: Any]? { get }
}

extension EndPoint {
    var getRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = header
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        return request
    }
}
