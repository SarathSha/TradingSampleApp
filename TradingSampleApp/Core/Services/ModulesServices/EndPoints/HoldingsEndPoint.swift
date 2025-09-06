//
//  HoldingsEndPoint.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation

enum HoldingsEndPoint {
    case holdings
}

extension HoldingsEndPoint: EndPoint {
    var url: URL? {
        switch self {
        case .holdings:
            URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io")
        }
    }
    
    var method: String {
        "GET"
    }
    
    var header: [String : String] {
        ["Accept": "application/json"]
    }
    
    var body: [String : Any]? {
        nil
    }
}
