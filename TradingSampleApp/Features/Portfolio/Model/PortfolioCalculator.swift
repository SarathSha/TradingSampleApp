//
//  PortfolioCalculator.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//
import Foundation

protocol PortfolioCalculatorProtocol {
    func calculatePortfolioSummary(from holdings: [HoldingsDisplayModel]) -> PortfolioSummary
}


final class PortfolioCalculator: PortfolioCalculatorProtocol {
    func calculatePortfolioSummary(from holdings: [HoldingsDisplayModel]) -> PortfolioSummary {
        let currentValue = calculateCurrentValue(from: holdings)
        let totalInvestment = calculateTotalInvestment(from: holdings)
        let totalPnl = calculateTotalPnl(currentValue: currentValue, totalInvestment: totalInvestment)
        let todaysPnl = calculateTodaysPnl(from: holdings)
        
        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPnl: totalPnl,
            todaysPnl: todaysPnl
        )
    }
    
    // MARK: - Public Calculation Methods
    
    
    /// Current Value = (Last Traded Price × Quantity) for all holdings
    func calculateCurrentValue(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            let holdingCurrentValue = holding.lastTradedPrice * Double(holding.quantity)
            return total + holdingCurrentValue
        }
    }
    
    /// Total Investment = (Average Price × Quantity) for all holdings
    func calculateTotalInvestment(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            let holdingTotalInvestment = holding.averagePrice * Double(holding.quantity)
            return total + holdingTotalInvestment
        }
    }
    
    /// Total P&L = Current Value - Total Investment
    func calculateTotalPnl(currentValue: Double, totalInvestment: Double) -> Double {
        currentValue - totalInvestment
    }
    
    /// Today's P&L = ((Close Price - Last Traded Price) × Quantity) for all holdings
    func calculateTodaysPnl(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            let holdingTodaysPnl = (holding.closePrice - holding.lastTradedPrice) * Double(holding.quantity)
            return total + holdingTodaysPnl
        }
    }
}
