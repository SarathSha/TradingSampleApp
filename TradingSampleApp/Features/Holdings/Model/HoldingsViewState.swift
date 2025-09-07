//
//  HoldingsViewState.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import Foundation

enum HoldingsViewState: Equatable {
    case loading, loaded, error(Error)
    
    static func == (lhs: HoldingsViewState, rhs: HoldingsViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            true
        case (.loaded, .loaded):
            true
        case (.error, .error):
            true
        default:
            false
        }
    }
}
