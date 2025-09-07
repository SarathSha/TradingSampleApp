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

    func refreshHoldings() async throws -> [HoldingsDisplayModel] {
        do {
            let apiHoldings = try await holdingsService.getHoldings().userHolding
            try await holdingsLocalDataSource.saveHoldings(apiHoldings)
            
            let savedHoldings = try await holdingsLocalDataSource.fetchHoldings()
            return savedHoldings.map { HoldingsDisplayModel(from: $0) }
        } catch {
            // If api fails, try to return cached data
            print("failed to load holdings from API, falling back to cache: \(error)")
            do {
                let localHoldings = try await holdingsLocalDataSource.fetchHoldings()
                print("loading from cache from catch block")
                return localHoldings.map { HoldingsDisplayModel(from: $0) }
            } catch {
                throw error
            }
        }
    }

    func fetchHoldings() async throws -> [HoldingsDisplayModel] {
        // First try to fetch from cache
        do {
            let cachedHoldings = try await holdingsLocalDataSource.fetchHoldings()
            if !cachedHoldings.isEmpty {
                print("loading from local store cache")
                return cachedHoldings.map { HoldingsDisplayModel(from: $0) }
            }
        } catch {
            // If cache fetch fails, continue to API call
            print("error \(#function): \(error)")
            throw error
        }

        // If no cached data, fetch from API
        return try await refreshHoldings()
    }
}
