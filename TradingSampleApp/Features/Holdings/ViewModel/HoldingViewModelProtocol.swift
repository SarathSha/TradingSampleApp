//
//  HoldingViewModelProtocol.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

protocol HoldingViewModelProtocol: AnyObject {
    func loadHoldings()
    var holdingsList: [HoldingsDisplayModel] { get set }
    var viewState: HoldingsViewState { get }
    var onStateChange: (() -> Void)? { get set }
}
