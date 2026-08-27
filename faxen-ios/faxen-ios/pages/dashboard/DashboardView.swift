//
//  DashboardView.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

struct DashboardView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppTheme.self) private var theme

    @State private var showSettings = false

    var body: some View {
        let metrics = theme.metrics

        ZStack {
            FaxenBackground()

            VStack(spacing: 0) {
                HStack {
                    Spacer(minLength: 0)

                    Button {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                            showSettings = true
                        }
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.faxenForeground)
                            .frame(width: 36, height: 36)
                            .background(Color.faxenCard, in: Circle())
                            .overlay(Circle().stroke(Color.faxenBorder))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Settings")
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                VStack(spacing: metrics.spacing) {
                    Text("Dashboard")
                        .font(.system(size: metrics.titleFont + 8, weight: .bold))
                        .foregroundStyle(Color.faxenForeground)

                    FaxenSecondaryButton(title: "go to home") {
                        appRouter.go(to: .home)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .safeAreaPadding(.top)
            .safeAreaPadding(.bottom)

            if showSettings {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(Color.black.opacity(theme.isDark ? 0.35 : 0.18))
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                            showSettings = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)

                SettingsPanel(isPresented: $showSettings)
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
            }
        }
    }
}

#Preview {
    DashboardView()
        .previewAppEnvironment()
}
