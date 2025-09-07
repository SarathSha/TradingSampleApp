//
//  HoldingService.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation

protocol HoldingService {
    func getHoldings() async throws -> HoldingsResponse
}

final class HoldingServiceImpl: HoldingService {
    private var client: HTTPClient

    init(client: HTTPClient = HTTPClientImpl()) {
        self.client = client
    }

    func getHoldings() async throws -> HoldingsResponse {
        try await client.perform(endPoint: HoldingsEndPoint.holdings,
                       responseModelType: Response.self)
        .data
    }
}
