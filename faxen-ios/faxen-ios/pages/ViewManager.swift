//
//  ViewManager.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI
import ClerkKit

enum AppRoute: Hashable {
    case home
    case onboarding
    case dashboard
}

struct ViewManager: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppTheme.self) private var theme

    var body: some View {
        Group {
            switch appRouter.current {
            case .home:
                LandingView()
            case .onboarding:
                SetupViews()
            case .dashboard:
                DashboardView()
            }
        }
        .preferredColorScheme(theme.colorScheme)
    }
}

struct PreviewAppEnvironment: ViewModifier {
    @State private var appRouter = AppRouter()
    @State private var screenRouter = ScreenRouter()
    @State private var theme = AppTheme()

    func body(content: Content) -> some View {
        content
            .environment(appRouter)
            .environment(screenRouter)
            .environment(theme)
            .environment(Clerk.shared)
            .preferredColorScheme(theme.colorScheme)
    }
}

extension View {
    func previewAppEnvironment() -> some View {
        modifier(PreviewAppEnvironment())
    }
}

#Preview {
    ViewManager()
        .previewAppEnvironment()
}
