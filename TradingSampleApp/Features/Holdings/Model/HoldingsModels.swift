//
//  HoldingsModels.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import UIKit

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

// MARK: - UI Models

struct HoldingsDisplayModel: Equatable {
    let symbol: String
    let quantity: Int
    let lastTradedPrice: Double
    let averagePrice: Double
    let closePrice: Double
    let currentValue: Double
    let totalInvestment: Double
    let pnl: Double
    let todaysPnl: Double
    let pnlPercentage: Double
    let isProfit: Bool
    let isTodaysProfit: Bool
    
    init(from holding: Holdings) {
        self.symbol = holding.symbol ?? ""
        self.quantity = Int(holding.quantity)
        self.lastTradedPrice = holding.lastTradedPrice
        self.averagePrice = holding.averagePrice
        self.closePrice = holding.closePrice
        self.currentValue = holding.currentValue
        self.totalInvestment = holding.totalInvestment
        self.pnl = holding.pnl
        self.todaysPnl = holding.todaysPnl
        self.pnlPercentage = holding.totalInvestment > 0 ? (holding.pnl / holding.totalInvestment) * 100 : 0
        self.isProfit = holding.isProfit
        self.isTodaysProfit = holding.isTodaysProfit
    }
}

// MARK: - Holdings Cell Data

struct HoldingsCellData {
    let symbol: String
    let quantity: String
    let lastTradedPrice: String
    let pnl: String
    let pnlColor: UIColor
    
    init(from displayModel: HoldingsDisplayModel) {
        self.symbol = displayModel.symbol
        self.quantity = "\(displayModel.quantity)"
        self.lastTradedPrice = "₹ \(String(format: "%.2f", displayModel.lastTradedPrice))"
        self.pnl = "₹ \(String(format: "%.2f", displayModel.pnl))"
        self.pnlColor = displayModel.isProfit ? .systemGreen : .systemRed
    }
}
