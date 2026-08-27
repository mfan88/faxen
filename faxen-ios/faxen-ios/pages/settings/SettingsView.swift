//
//  SettingsView.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

struct SettingsPanel: View {
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { geo in
            let panelWidth = min(geo.size.width * 0.92, geo.size.width - 16)

            HStack(spacing: 0) {
                Spacer(minLength: 0)

                SettingsView {
                    close()
                }
                .frame(width: panelWidth)
                .frame(maxHeight: .infinity)
                .background {
                    ZStack {
                        FaxenBackground(ignoresSafeArea: false)
                        Color.faxenCard.opacity(0.55)
                    }
                }
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 28,
                        bottomLeadingRadius: 28,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0,
                        style: .continuous
                    )
                )
                .overlay(alignment: .leading) {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 28,
                        bottomLeadingRadius: 28,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0,
                        style: .continuous
                    )
                    .stroke(Color.faxenBorder)
                }
                .shadow(color: .black.opacity(0.18), radius: 28, x: -8)
                .padding(.vertical, 10)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width > 80 {
                                close()
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .allowsHitTesting(true)
    }

    private func close() {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
            isPresented = false
        }
    }
}

struct SettingsView: View {
    var onClose: () -> Void = {}

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.faxenForeground)
                        .frame(width: 36, height: 36)
                        .background(
                            colorScheme == .dark ? Color.black.opacity(0.22) : Color.white.opacity(0.55),
                            in: Circle()
                        )
                        .overlay(Circle().stroke(Color.faxenBorder))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close settings")

                Spacer(minLength: 0)

                Text("Settings")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.faxenForeground)

                Spacer(minLength: 0)

                Color.clear
                    .frame(width: 36, height: 36)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    settingsSection(
                        title: "appearance",
                        subtitle: "light or dark mode"
                    ) {
                        AppearancePicker(compact: true)
                    }

                    settingsSection(
                        title: "view mode",
                        subtitle: "expressive or compact layout"
                    ) {
                        ViewModePicker(compact: true)
                    }

                    settingsSection(
                        title: "size",
                        subtitle: "scale of buttons, type, and components"
                    ) {
                        SizeControl()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
            .scrollContentBackground(.hidden)
        }
        .safeAreaPadding(.top)
        .safeAreaPadding(.bottom)
    }

    private func settingsSection<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.faxenForeground)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.faxenMuted)
            }

            content()
        }
    }
}

#Preview {
    ZStack {
        FaxenBackground()
        SettingsPanel(isPresented: .constant(true))
    }
    .previewAppEnvironment()
}
