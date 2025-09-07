//
//  PortfolioCalculatorTests.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//
import XCTest
@testable import TradingSampleApp

final class PortfolioCalculatorTests: XCTestCase {
    
    var calculator: PortfolioCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = PortfolioCalculator()
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testCalculatePortfolioSummary_WithValidHoldings_ReturnsCorrectSummary() {
        // Given
        let holdings = createSampleHoldings()
        
        // When
        let summary = calculator.calculatePortfolioSummary(from: holdings)
        
        // Then - Calculate expected values manually
        let expectedCurrentValue = 20626.20
        let expectedTotalInvestment = 21911.00
        let expectedTotalPnl = -1284.80
        let expectedTodaysPnl = -13.20
        let expectedTotalPnlPercentage = -5.86
        
        XCTAssertEqual(summary.currentValue, expectedCurrentValue, accuracy: 0.01)
        XCTAssertEqual(summary.totalInvestment, expectedTotalInvestment, accuracy: 0.01)
        XCTAssertEqual(summary.totalPnl, expectedTotalPnl, accuracy: 0.01)
        XCTAssertEqual(summary.todaysPnl, expectedTodaysPnl, accuracy: 0.01)
        XCTAssertEqual(summary.totalPnlPercentage, expectedTotalPnlPercentage, accuracy: 0.01)
        XCTAssertFalse(summary.isTotalProfit)
        XCTAssertFalse(summary.isTodaysProfit)
    }
    
    func testCalculatePortfolioSummary_WithEmptyHoldings_ReturnsZeroValues() {
        // Given
        let holdings: [HoldingsDisplayModel] = []
        
        // When
        let summary = calculator.calculatePortfolioSummary(from: holdings)
        
        // Then
        XCTAssertEqual(summary.currentValue, 0)
        XCTAssertEqual(summary.totalInvestment, 0)
        XCTAssertEqual(summary.totalPnl, 0)
        XCTAssertEqual(summary.todaysPnl, 0)
        XCTAssertEqual(summary.totalPnlPercentage, 0)
        XCTAssertTrue(summary.isTotalProfit)
        XCTAssertTrue(summary.isTodaysProfit)
    }
    
    func testCalculatePortfolioSummary_WithProfitHoldings_ReturnsPositivePnl() {
        // Given
        let holdings = [
            createHolding(symbol: "TEST1", quantity: 10, ltp: 100, avgPrice: 90, close: 95),
            createHolding(symbol: "TEST2", quantity: 5, ltp: 200, avgPrice: 180, close: 190)
        ]
        /*
         product 1:
         current value = 100 * 10 = 1000
         investment = 90 * 10 = 900
         pnl = 1000 - 900 = 100
         today pnl = (95 - 100) * 10 = -50
         
         product 2:
         current value = 200 * 5 = 1000
         investment = 180 * 5 = 900
         pnl = 1000 - 900 = 100
         today pnl = (190 - 200) * 5 = -50
         
         total
         current = 1000 + 1000 = 2000
         investment = 900 + 900 = 1800
         pnl = 100 + 100 = 200
         today pnl = -50 -50 = -100
         */
        // When
        let summary = calculator.calculatePortfolioSummary(from: holdings)
        
        // Then
        XCTAssertEqual(summary.currentValue, 2000) // (10*100) + (5*200)
        XCTAssertEqual(summary.totalInvestment, 1800) // (10*90) + (5*180)
        XCTAssertEqual(summary.totalPnl, 200) // 2000 - 1800
        XCTAssertEqual(summary.todaysPnl, -100) // (10*-5) + (-5*10)
        XCTAssertEqual(summary.totalPnlPercentage, 11.11, accuracy: 0.01) // (200/1800)*100
        XCTAssertTrue(summary.isTotalProfit)
        XCTAssertFalse(summary.isTodaysProfit)
    }
    
    // MARK: - Helper Methods
    
    private func createSampleHoldings() -> [HoldingsDisplayModel] {
        return [
            createHolding(symbol: "ASHOKLEY", quantity: 3, ltp: 119.10, avgPrice: 115.00, close: 120.00),
            createHolding(symbol: "HDFC", quantity: 7, ltp: 2497.20, avgPrice: 2700.00, close: 2500.00),
            createHolding(symbol: "ICICIBANK", quantity: 1, ltp: 624.70, avgPrice: 500.00, close: 600.00),
            createHolding(symbol: "IDEA", quantity: 3, ltp: 9.95, avgPrice: 9.00, close: 9.50),
            createHolding(symbol: "IDEA", quantity: 71, ltp: 9.95, avgPrice: 9.00, close: 9.50),
            createHolding(symbol: "INDHOTEL", quantity: 10, ltp: 142.75, avgPrice: 150.00, close: 145.00)
        ]
    }
    
    private func createHolding(symbol: String, quantity: Int, ltp: Double, avgPrice: Double, close: Double) -> HoldingsDisplayModel {
        let currentValue = ltp * Double(quantity)
        let totalInvestment = avgPrice * Double(quantity)
        let pnl = currentValue - totalInvestment
        let todaysPnl = (close - ltp) * Double(quantity)
        
        return HoldingsDisplayModel(
            symbol: symbol,
            quantity: quantity,
            lastTradedPrice: ltp,
            averagePrice: avgPrice,
            closePrice: close,
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            pnl: pnl,
            todaysPnl: todaysPnl,
            pnlPercentage: totalInvestment > 0 ? (pnl / totalInvestment) * 100 : 0,
            isProfit: pnl >= 0,
            isTodaysProfit: todaysPnl >= 0,
            isT1Holding: false
        )
    }
}
