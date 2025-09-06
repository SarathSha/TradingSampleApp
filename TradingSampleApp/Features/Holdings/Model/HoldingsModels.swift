//
//  HoldingsModels.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation

struct Response: Codable {
    let data: HoldingsResponse
}
struct HoldingsResponse: Codable {
    let userHolding: [HoldingsAPIResponse]
}

struct HoldingsAPIResponse: Codable {
    let symbol: String
    let quantity: Int
    let avgPrice: Double
    let ltp: Double
    let close: Double
}
