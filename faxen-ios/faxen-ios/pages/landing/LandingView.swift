//
//  LandingView.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

struct LandingView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppTheme.self) private var theme

    var body: some View {
        let metrics = theme.metrics

        ZStack {
            FaxenBackground()

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                hero(metrics)
                getStarted(metrics)

                Spacer(minLength: 24)

                footer
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func hero(_ metrics: FaxenMetrics) -> some View {
        VStack(spacing: 0) {
            Text("built by fenna.tech")
                .font(.system(size: 12, weight: .medium))
                .tracking(0.4)
                .foregroundStyle(Color.faxenMuted)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.faxenCard, in: Capsule())
                .overlay(Capsule().stroke(Color.faxenBorder))
                .padding(.bottom, metrics.spacing)

            FoxLockup(size: metrics.logoSize)

            Text("send files with confidence. encrypted, access-controlled, and built for the moments when an email attachment isn't enough.")
                .font(.system(size: metrics.titleFont, weight: .regular, design: .serif))
                .foregroundStyle(Color.faxenForeground)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .tracking(-0.3)
                .padding(.top, metrics.spacing)
                .frame(maxWidth: 480)
        }
    }

    private func getStarted(_ metrics: FaxenMetrics) -> some View {
        FaxenPrimaryButton(title: "get started") {
            appRouter.go(to: .onboarding)
        }
        .padding(.top, metrics.spacing)
    }

    private var footer: some View {
        Text("© 2026 faxen. files made easy.")
            .font(.system(size: 12))
            .foregroundStyle(Color.faxenMuted)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    LandingView()
        .previewAppEnvironment()
}
