//
//  MockHoldingRepository.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//
@testable import TradingSampleApp
class MockHoldingsRepository: HoldingsRepositoryProtocol {
    var mockHoldings: [HoldingsDisplayModel] = []
    var shouldThrowError = false
    var refreshHoldingsCalled = false
    
    func fetchHoldings() async throws -> [HoldingsDisplayModel] {
        if shouldThrowError {
            throw NetworkError.noInternetConnection
        }
        return mockHoldings
    }
    
    func refreshHoldings() async throws -> [HoldingsDisplayModel] {
        refreshHoldingsCalled = true
        if shouldThrowError {
            throw NetworkError.noInternetConnection
        }
        return mockHoldings
    }
}
