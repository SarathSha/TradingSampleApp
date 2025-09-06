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
    
    // MARK: - Private Calculation Methods
    
    private func calculateCurrentValue(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            total + holding.currentValue
        }
    }
    
    private func calculateTotalInvestment(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            total + holding.totalInvestment
        }
    }
    
    private func calculateTotalPnl(currentValue: Double, totalInvestment: Double) -> Double {
        currentValue - totalInvestment
    }
    
    private func calculateTodaysPnl(from holdings: [HoldingsDisplayModel]) -> Double {
        holdings.reduce(0) { total, holding in
            total + holding.todaysPnl
        }
    }
}
