//
//  HoldingsRepository.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation
final class HoldingsRepository: HoldingsRepositoryProtocol {
    
    private let holdingsService: HoldingService
    
    init(holdingsService: HoldingService = HoldingServiceImpl()) {
        self.holdingsService = holdingsService
    }
    
    func fetchHoldings() async throws -> [HoldingsAPIResponse] {
        try await holdingsService.getHoldings().userHolding
    }
}
