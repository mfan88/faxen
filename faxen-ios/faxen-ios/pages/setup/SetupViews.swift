//
//  SetupViews.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI
import ClerkKit

enum SetupScreens: Hashable, CaseIterable {
    case appearance
    case viewMode
    case size
    case account

    var title: String {
        switch self {
        case .appearance: "choose your look"
        case .viewMode: "how should faxen feel?"
        case .size: "set a comfortable size"
        case .account: "join faxen"
        }
    }

    var subtitle: String {
        switch self {
        case .appearance: "light or dark — you can change this anytime."
        case .viewMode: "expressive is roomy. compact keeps more on screen."
        case .size: "this scales buttons, type, and other components."
        case .account: "sign in or create an account — you can skip this for now."
        }
    }
}

struct SetupViews: View {
    @Environment(ScreenRouter.self) private var screenRouter
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppTheme.self) private var theme

    var body: some View {
        ZStack {
            FaxenBackground()

            RadialGradient(
                colors: [
                    Color.faxenAccent.opacity(theme.isDark ? 0.50 : 0.34),
                    Color.faxenAccent.opacity(theme.isDark ? 0.18 : 0.12),
                    .clear
                ],
                center: UnitPoint(x: 0.5, y: 0.38),
                startRadius: 20,
                endRadius: 440
            )
            .blur(radius: 24)
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                progress
                    .padding(.top, 4)

                if screenRouter.current == .account {
                    Spacer().frame(height: 4)
                } else {
                    header
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                }

                Group {
                    switch screenRouter.current {
                    case .appearance:
                        AppearanceView()
                    case .viewMode:
                        ViewModeView()
                    case .size:
                        SizeView()
                    case .account:
                        AccountView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(0)

                navigationButtons
                    .padding(.top, 16)
                    .layoutPriority(1)
            }
            .padding(.horizontal, 20)
            .safeAreaPadding(.top)
            .safeAreaPadding(.bottom)
        }
        .preferredColorScheme(theme.colorScheme)
    }

    private var progress: some View {
        HStack(spacing: 8) {
            ForEach(SetupScreens.allCases, id: \.self) { step in
                Capsule()
                    .fill(step == screenRouter.current ? Color.faxenAccent : Color.faxenBorder)
                    .frame(width: step == screenRouter.current ? 22 : 8, height: 8)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(screenRouter.current.title)
                .font(.system(size: 28, weight: .regular, design: .serif))
                .foregroundStyle(Color.faxenForeground)
                .multilineTextAlignment(.center)

            Text(screenRouter.current.subtitle)
                .font(.system(size: 15))
                .foregroundStyle(Color.faxenMuted)
                .multilineTextAlignment(.center)
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            if screenRouter.current != .appearance {
                FaxenSecondaryButton(title: "back", scaled: false) {
                    withAnimation(.easeInOut) {
                        screenRouter.retreat()
                    }
                }
            }

            Spacer(minLength: 0)

            FaxenPrimaryButton(title: screenRouter.current == .account ? "finish" : "continue", scaled: false) {
                withAnimation(.easeInOut) {
                    if screenRouter.current == .account {
                        appRouter.go(to: .dashboard)
                    } else {
                        screenRouter.advance()
                    }
                }
            }
        }
    }
}

struct AppearanceView: View {
    var body: some View {
        AppearancePicker(axis: .vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ViewModeView: View {
    var body: some View {
        ViewModePicker(axis: .vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SizeView: View {
    var body: some View {
        SizeControl(compactSlider: true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AccountView: View {
    var body: some View {
        FaxenAuthView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview("Appearance") {
    AppearanceView()
        .padding()
        .background { FaxenBackground() }
        .previewAppEnvironment()
}

#Preview("View mode") {
    ViewModeView()
        .padding()
        .background { FaxenBackground() }
        .previewAppEnvironment()
}

#Preview("Size") {
    SizeView()
        .padding()
        .background { FaxenBackground() }
        .previewAppEnvironment()
}

#Preview("Account") {
    AccountView()
        .previewAppEnvironment()
}

#Preview("Setup") {
    SetupViews()
        .previewAppEnvironment()
}
