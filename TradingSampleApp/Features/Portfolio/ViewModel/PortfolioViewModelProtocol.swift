//
//  PortfolioViewModelProtocol.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//

import Foundation

protocol PortfolioViewModelProtocol: AnyObject {
    var portfolioSummary: PortfolioSummary? { get }
    var viewState: PortfolioViewState { get }
    var onStateChange: (() -> Void)? { get set }
    
    func updatePortfolioSummary(from holdings: [HoldingsDisplayModel])
    func toggleExpandedState()
    func setExpandedState(_ isExpanded: Bool)
}
