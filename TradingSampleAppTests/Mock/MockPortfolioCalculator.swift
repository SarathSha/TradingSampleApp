//
//  MockPortfolioCalculator.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//
@testable import TradingSampleApp

class MockPortfolioCalculator: PortfolioCalculatorProtocol {
    var mockSummary: PortfolioSummary?
    
    func calculatePortfolioSummary(from holdings: [HoldingsDisplayModel]) -> PortfolioSummary {
        mockSummary ?? PortfolioSummary(
            currentValue: 0,
            totalInvestment: 0,
            totalPnl: 0,
            todaysPnl: 0
        )
    }
    
    func calculateCurrentValue(from holdings: [HoldingsDisplayModel]) -> Double {
        mockSummary?.currentValue ?? 0
    }
    
    func calculateTotalInvestment(from holdings: [HoldingsDisplayModel]) -> Double {
        mockSummary?.totalInvestment ?? 0
    }
    
    func calculateTotalPnl(currentValue: Double, totalInvestment: Double) -> Double {
        mockSummary?.totalPnl ?? 0
    }
    
    func calculateTodaysPnl(from holdings: [HoldingsDisplayModel]) -> Double {
        mockSummary?.todaysPnl ?? 0
    }
}
