//
//  PortfolioViewModelTest.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//

import XCTest
@testable import TradingSampleApp

final class PortfolioViewModelTests: XCTestCase {
    
    var viewModel: PortfolioViewModel!
    var mockCalculator: MockPortfolioCalculator!
    
    override func setUp() {
        super.setUp()
        mockCalculator = MockPortfolioCalculator()
        viewModel = PortfolioViewModel(calculator: mockCalculator)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCalculator = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInitialState_IsCollapsed() {
        // Then
        XCTAssertEqual(viewModel.viewState, .collapsed)
        XCTAssertNil(viewModel.portfolioSummary)
    }
    
    func testUpdatePortfolioSummary_WithValidHoldings_UpdatesSummary() {
        // Given
        let holdings = createSampleHoldings()
        let expectedSummary = PortfolioSummary(
            currentValue: 1000,
            totalInvestment: 900,
            totalPnl: 100,
            todaysPnl: 50
        )
        mockCalculator.mockSummary = expectedSummary
        
        // When
        viewModel.updatePortfolioSummary(from: holdings)
        
        // Then
        XCTAssertEqual(viewModel.portfolioSummary, expectedSummary)
    }
    
    func testToggleExpandedState_FromCollapsed_ChangesToExpanded() {
        // Given
        XCTAssertEqual(viewModel.viewState, .collapsed)
        
        // When
        viewModel.toggleExpandedState()
        
        // Then
        XCTAssertEqual(viewModel.viewState, .expanded)
    }
    
    func testToggleExpandedState_FromExpanded_ChangesToCollapsed() {
        // Given
        viewModel.setExpandedState(true)
        XCTAssertEqual(viewModel.viewState, .expanded)
        
        // When
        viewModel.toggleExpandedState()
        
        // Then
        XCTAssertEqual(viewModel.viewState, .collapsed)
    }
    
    func testSetExpandedState_WithTrue_SetsToExpanded() {
        // Given
        XCTAssertEqual(viewModel.viewState, .collapsed)
        
        // When
        viewModel.setExpandedState(true)
        
        // Then
        XCTAssertEqual(viewModel.viewState, .expanded)
    }
    
    func testSetExpandedState_WithFalse_SetsToCollapsed() {
        // Given
        viewModel.setExpandedState(true)
        XCTAssertEqual(viewModel.viewState, .expanded)
        
        // When
        viewModel.setExpandedState(false)
        
        // Then
        XCTAssertEqual(viewModel.viewState, .collapsed)
    }
    
    func testSetExpandedState_WithSameState_DoesNotChange() {
        // Given
        let expectation = XCTestExpectation(description: "State change notification")
        expectation.isInverted = true
        
        viewModel.onStateChange = {
            expectation.fulfill()
        }
        
        // When
        viewModel.setExpandedState(false) // Already collapsed
        
        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(viewModel.viewState, .collapsed)
    }
    
    func testOnStateChange_IsCalled_WhenStateChanges() {
        // Given
        let expectation = XCTestExpectation(description: "State change notification")
        var callCount = 0
        
        viewModel.onStateChange = {
            callCount += 1
            expectation.fulfill()
        }
        
        // When
        viewModel.toggleExpandedState()
        
        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(callCount, 1)
    }
    
    // MARK: - Helper Methods
    
    private func createSampleHoldings() -> [HoldingsDisplayModel] {
        [
            HoldingsDisplayModel(
                symbol: "TEST1",
                quantity: 10,
                lastTradedPrice: 100,
                averagePrice: 90,
                closePrice: 95,
                currentValue: 1000,
                totalInvestment: 900,
                pnl: 100,
                todaysPnl: 50,
                pnlPercentage: 11.11,
                isProfit: true,
                isTodaysProfit: true,
                isT1Holding: false
            )
        ]
    }
}
