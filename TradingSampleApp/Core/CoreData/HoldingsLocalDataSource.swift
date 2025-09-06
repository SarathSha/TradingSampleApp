//
//  HoldingsLocalDataSource.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation
import CoreData

protocol HoldingsLocalDataSource {
    func saveHoldings(_ holdings: [HoldingsAPIResponse]) async throws
    func clearAllHoldings() async throws
    func fetchHoldings() async throws -> [Holdings]
}

final class HoldingsLocalDataSourceImpl: HoldingsLocalDataSource {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    func saveHoldings(_ holdings: [HoldingsAPIResponse]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    // Clear existing holdings
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Holdings.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(deleteRequest)

                    // Save new holdings
                    for holdingResponse in holdings {
                        let holding = Holdings(context: context)
                        holding.symbol = holdingResponse.symbol
                        holding.quantity = Int32(holdingResponse.quantity)
                        holding.lastTradedPrice = holdingResponse.ltp
                        holding.averagePrice = holdingResponse.avgPrice
                        holding.closePrice = holdingResponse.close
                        holding.currentValue = holdingResponse.ltp * Double(holdingResponse.quantity)
                        holding.totalInvestment = holdingResponse.avgPrice * Double(holdingResponse.quantity)
                        holding.pnl = (holdingResponse.ltp - holdingResponse.avgPrice) * Double(holdingResponse.quantity)
                        holding.todaysPnl = (holdingResponse.ltp - holdingResponse.close) * Double(holdingResponse.quantity)
                        holding.isProfit = holding.pnl >= 0
                        holding.isTodaysProfit = holding.todaysPnl >= 0
                        holding.lastUpdated = Date()
                    }
                    
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: CoreDataError.saveError(error))
                }
            }
        }
    }
    
    func fetchHoldings() async throws -> [Holdings] {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                let fetchRequest = Holdings.fetchRequest()
                do {
                    let holdings = try context.fetch(fetchRequest)
                    continuation.resume(returning: holdings)
                } catch {
                    continuation.resume(throwing: CoreDataError.fetchError(error))
                }
            }
        }
    }
    
    func clearAllHoldings() async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Holdings.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(deleteRequest)
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: CoreDataError.deleteError(error))
                }
            }
        }
    }
}

// MARK: - CoreData Errors

enum CoreDataError: Error, LocalizedError {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    
    var errorDescription: String? {
        switch self {
        case .saveError(let error):
            "Failed to save data: \(error.localizedDescription)"
        case .fetchError(let error):
            "Failed to fetch data: \(error.localizedDescription)"
        case .deleteError(let error):
            "Failed to delete data: \(error.localizedDescription)"
        }
    }
}
