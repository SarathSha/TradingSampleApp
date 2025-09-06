//
//  HoldingsViewModel.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import Foundation
final class HoldingsViewModel: HoldingViewModelProtocol {

    private(set) var viewState: HoldingsViewState = .loading {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.onStateChange?()
            }
        }
    }
    
    var onStateChange: (() -> Void)?
    private let repository: HoldingsRepositoryProtocol
    
    var holdingsList: [HoldingsDisplayModel] = []
    init(repository: HoldingsRepositoryProtocol = HoldingsRepository()) {
        self.repository = repository
    }

    func loadHoldings() {
        viewState = .loading
        Task {
            do {
                let holdings = try await repository.fetchHoldings()
                holdingsList = holdings
                viewState = .loaded
            } catch {
                print("error: \(error)")
            }
        }
    }
}
