//
//  PortfolioViewModel.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//

import Foundation

final class PortfolioViewModel: PortfolioViewModelProtocol {
    
    // MARK: - Properties
    
    private(set) var portfolioSummary: PortfolioSummary?
    private(set) var viewState: PortfolioViewState = .collapsed
    
    var onStateChange: (() -> Void)?
    
    // MARK: - Dependencies
    
    private let calculator: PortfolioCalculatorProtocol
    
    // MARK: - Initialization
    
    init(calculator: PortfolioCalculatorProtocol = PortfolioCalculator()) {
        self.calculator = calculator
    }
    
    // MARK: - Public Methods
    
    func updatePortfolioSummary(from holdings: [HoldingsDisplayModel]) {
        portfolioSummary = calculator.calculatePortfolioSummary(from: holdings)
        notifyStateChange()
    }
    
    func toggleExpandedState() {
        viewState.toggle()
        notifyStateChange()
    }
    
    func setExpandedState(_ isExpanded: Bool) {
        let newState: PortfolioViewState = isExpanded ? .expanded : .collapsed
        if viewState != newState {
            viewState = newState
            notifyStateChange()
        }
    }

    // MARK: - Private Methods

    private func notifyStateChange() {
        DispatchQueue.main.async { [weak self] in
            self?.onStateChange?()
        }
    }
}
