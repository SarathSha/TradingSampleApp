//
//  HoldingRepositoryProtocol.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

protocol HoldingsRepositoryProtocol {
    func fetchHoldings() async throws -> [HoldingsDisplayModel]
}
