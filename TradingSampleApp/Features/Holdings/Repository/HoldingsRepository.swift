//
//  HoldingsRepository.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation
final class HoldingsRepository: HoldingsRepositoryProtocol {

    private let holdingsService: HoldingService
    private let holdingsLocalDataSource: HoldingsLocalDataSource

    init(holdingsService: HoldingService = HoldingServiceImpl(),
    holdingsLocalDataSource: HoldingsLocalDataSource = HoldingsLocalDataSourceImpl()) {
        self.holdingsService = holdingsService
        self.holdingsLocalDataSource = holdingsLocalDataSource
    }

    func fetchHoldings() async throws -> [HoldingsDisplayModel] {
        do {
            let apiHoldings = try await holdingsService.getHoldings().userHolding
            try await holdingsLocalDataSource.saveHoldings(apiHoldings)
            let displayModel = apiHoldings.compactMap { apiHolding in
                // Create a temporary Holdings object to use the computed properties
                let context = CoreDataStack.shared.viewContext
                let holding = Holdings(context: context)
                holding.symbol = apiHolding.symbol
                holding.quantity = Int32(apiHolding.quantity)
                holding.lastTradedPrice = apiHolding.ltp
                holding.averagePrice = apiHolding.avgPrice
                holding.closePrice = apiHolding.close
                holding.currentValue = apiHolding.ltp * Double(apiHolding.quantity)
                holding.totalInvestment = apiHolding.avgPrice * Double(apiHolding.quantity)
                holding.pnl = (apiHolding.ltp - apiHolding.avgPrice) * Double(apiHolding.quantity)
                holding.todaysPnl = (apiHolding.ltp - apiHolding.close) * Double(apiHolding.quantity)
                holding.isProfit = holding.pnl >= 0
                holding.isTodaysProfit = holding.todaysPnl >= 0
                holding.lastUpdated = Date()
                return HoldingsDisplayModel(from: holding)
            }
            return displayModel
        } catch {
            // If api fails, try to return cached data
            do {
                let localHoldings = try await holdingsLocalDataSource.fetchHoldings()
                return localHoldings.map { HoldingsDisplayModel(from: $0) }
            } catch {
                throw error
            }
        }
    }
}
