//
//  PortfolioModels.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//

import UIKit

// MARK: - Portfolio Summary Model

struct PortfolioSummary: Equatable {
    let currentValue: Double
    let totalInvestment: Double
    let totalPnl: Double
    let todaysPnl: Double
    let totalPnlPercentage: Double
    let isTotalProfit: Bool
    let isTodaysProfit: Bool
    
    init(currentValue: Double, totalInvestment: Double, totalPnl: Double, todaysPnl: Double) {
        self.currentValue = currentValue
        self.totalInvestment = totalInvestment
        self.totalPnl = totalPnl
        self.todaysPnl = todaysPnl
        self.totalPnlPercentage = totalInvestment > 0 ? (totalPnl / totalInvestment) * 100 : 0
        self.isTotalProfit = totalPnl >= 0
        self.isTodaysProfit = todaysPnl >= 0
    }
}

// MARK: - Portfolio Display Data

struct PortfolioDisplayData {
    let currentValueText: String
    let totalInvestmentText: String
    let totalPnlText: String
    let todaysPnlText: String
    let totalPnlPercentageText: String
    let totalPnlColor: UIColor
    let todaysPnlColor: UIColor
    
    init(from summary: PortfolioSummary) {
        self.currentValueText = "₹ \(String(format: "%.2f", summary.currentValue))"
        self.totalInvestmentText = "₹ \(String(format: "%.2f", summary.totalInvestment))"
        self.totalPnlText = "₹ \(String(format: "%.2f", summary.totalPnl))"
        self.todaysPnlText = "₹ \(String(format: "%.2f", summary.todaysPnl))"
        self.totalPnlPercentageText = "\(String(format: "%.2f", summary.totalPnlPercentage))%"
        self.totalPnlColor = summary.isTotalProfit ? .systemGreen : .systemRed
        self.todaysPnlColor = summary.isTodaysProfit ? .systemGreen : .systemRed
    }
}

// MARK: - Portfolio View State

enum PortfolioViewState: Equatable {
    case collapsed
    case expanded
    
    var isExpanded: Bool {
        switch self {
        case .collapsed:
            false
        case .expanded:
            true
        }
    }
    
    mutating func toggle() {
        switch self {
        case .collapsed:
            self = .expanded
        case .expanded:
            self = .collapsed
        }
    }
}
