//
//  Routes.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

@Observable
final class AppRouter {
    var current: AppRoute = .home

    func go(to route: AppRoute) {
        current = route
    }
}

@Observable
final class ScreenRouter {
    var current: SetupScreens = .appearance

    func go(to route: SetupScreens) {
        current = route
    }

    func advance() {
        switch current {
        case .appearance: current = .viewMode
        case .viewMode: current = .size
        case .size: current = .account
        case .account: break
        }
    }

    func retreat() {
        switch current {
        case .appearance: break
        case .viewMode: current = .appearance
        case .size: current = .viewMode
        case .account: current = .size
        }
    }
}
