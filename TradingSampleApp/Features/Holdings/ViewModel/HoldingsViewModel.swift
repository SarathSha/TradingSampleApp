//
//  HoldingsViewModel.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation
final class HoldingsViewModel: HoldingViewModelProtocol {
    
    private let repository: HoldingsRepositoryProtocol
    
    init(repository: HoldingsRepositoryProtocol = HoldingsRepository()) {
        self.repository = repository
    }
    func loadHoldings() {
        Task {
            do {
                let holdings = try await repository.fetchHoldings()
                print(holdings)
            }
        }
    }
}
