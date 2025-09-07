//
//  HoldingsViewModelTest.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//

import XCTest
@testable import TradingSampleApp

final class HoldingsViewModelTests: XCTestCase {
    
    var viewModel: HoldingsViewModel!
    var mockRepository: MockHoldingsRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockHoldingsRepository()
        viewModel = HoldingsViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.viewState, .loading)
    }
    
    func testLoadHoldingsSuccess() async {
        // Given
        let expectedHoldings = createMockHoldings()
        mockRepository.mockHoldings = expectedHoldings
        
        // When
        viewModel.loadHoldings()
        
        // Wait for async operation
        await waitForStateChange()
        
        // Then
        switch viewModel.viewState {
        case .loaded:
            XCTAssertEqual(viewModel.holdingsList.count, expectedHoldings.count)
        default:
            XCTFail("Expected loaded state")
        }
    }

    func testLoadHoldingsError() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        viewModel.loadHoldings()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        switch viewModel.viewState {
        case .error:
            break // Expected
        default:
            XCTFail("Expected error state")
        }
    }
    
    func testRefreshHoldings() async {
        // Given
        let expectedHoldings = createMockHoldings()
        mockRepository.mockHoldings = expectedHoldings
        
        // When
        viewModel.refresh()
        
        // Wait for async operation
        await waitForStateChange()
        
        // Then
        XCTAssertTrue(mockRepository.refreshHoldingsCalled)
        switch viewModel.viewState {
        case .loaded:
            XCTAssertEqual(viewModel.holdingsList.count, expectedHoldings.count)
        default:
            XCTFail("Expected loaded state")
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMockHoldings() -> [HoldingsDisplayModel] {
        let context = CoreDataStack.shared.viewContext
        let holding = Holdings(context: context)
        holding.symbol = "AAPL"
        holding.quantity = 10
        holding.lastTradedPrice = 150.0
        holding.averagePrice = 140.0
        holding.closePrice = 145.0
        
        return [HoldingsDisplayModel(from: holding)]
    }
    
    private func waitForStateChange() async {
        let expectation = XCTestExpectation(description: "State change")
        viewModel.onStateChange = {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
