//
//  DisplaySettings.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

struct AppearancePicker: View {
    @Environment(AppTheme.self) private var theme
    var compact: Bool = false
    var axis: Axis = .horizontal

    var body: some View {
        if axis == .vertical {
            VStack(spacing: 12) {
                option(isDark: false, title: "light", symbol: "sun.max.fill")
                option(isDark: true, title: "dark", symbol: "moon.fill")
            }
        } else {
            HStack(spacing: 12) {
                option(isDark: false, title: "light", symbol: "sun.max.fill")
                option(isDark: true, title: "dark", symbol: "moon.fill")
            }
        }
    }

    private func option(isDark: Bool, title: String, symbol: String) -> some View {
        let selected = theme.isDark == isDark

        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                theme.isDark = isDark
            }
        } label: {
            VStack(spacing: axis == .vertical ? 16 : 10) {
                Image(systemName: symbol)
                    .font(.system(size: axis == .vertical ? 44 : 28, weight: .medium))
                    .foregroundStyle(selected ? Color.faxenAccent : Color.faxenMuted)
                    .symbolRenderingMode(.hierarchical)

                Text(title)
                    .font(.system(size: 15, weight: selected ? .semibold : .medium))
                    .foregroundStyle(selected ? Color.faxenAccent : Color.faxenMuted)
            }
            .frame(maxWidth: .infinity, maxHeight: axis == .vertical ? .infinity : nil)
            .padding(.vertical, axis == .vertical ? 28 : 18)
            .padding(.horizontal, 16)
            .background(
                Color.faxenCard,
                in: RoundedRectangle(cornerRadius: 26, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(selected ? Color.faxenAccent : Color.faxenBorder, lineWidth: selected ? 2.5 : 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: axis == .vertical ? .infinity : nil)
        .accessibilityLabel("\(title) appearance")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct ViewModePreview: View {
    var mode: ViewMode
    var sizeScale: Double = 1

    @Environment(AppTheme.self) private var theme

    var body: some View {
        let s = CGFloat(sizeScale)

        ZStack {
            FaxenBackground(ignoresSafeArea: false)

            RadialGradient(
                colors: [
                    Color.faxenAccent.opacity(theme.isDark ? 0.28 : 0.14),
                    .clear
                ],
                center: UnitPoint(x: 0.5, y: 0.3),
                startRadius: 4,
                endRadius: 140
            )

            Group {
                if mode == .expressive {
                    expressiveCards(s)
                } else {
                    compactBanners(s)
                }
            }
            .padding(mode == .expressive ? 16 * max(s, 0.85) : 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(minHeight: 0)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.faxenBorder, lineWidth: 1)
        )
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var placeholder: Color {
        Color.faxenForeground.opacity(0.14)
    }

    private func compactBanners(_ s: CGFloat) -> some View {
        VStack(spacing: 8 * s) {
            ForEach(0..<3, id: \.self) { _ in
                HStack(spacing: 10 * s) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(placeholder)
                        .frame(width: 36 * s, height: 36 * s)

                    VStack(alignment: .leading, spacing: 6 * s) {
                        Capsule()
                            .fill(placeholder)
                            .frame(width: 92 * s, height: 7 * s)
                        Capsule()
                            .fill(placeholder.opacity(0.7))
                            .frame(width: 148 * s, height: 6 * s)
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 11 * s, weight: .semibold))
                        .foregroundStyle(Color.faxenMuted)
                }
                .padding(.horizontal, 12 * s)
                .padding(.vertical, 8 * s)
                .background(
                    Color.faxenCard,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.faxenBorder)
                )
            }

            Spacer(minLength: 0)
        }
    }

    private func expressiveCards(_ s: CGFloat) -> some View {
        let gap = 10 * s

        return LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: gap),
                GridItem(.flexible(), spacing: gap)
            ],
            spacing: gap
        ) {
            ForEach(0..<4, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 8 * s) {
                    RoundedRectangle(cornerRadius: 12 * s, style: .continuous)
                        .fill(placeholder)
                        .aspectRatio(1, contentMode: .fit)

                    Capsule()
                        .fill(placeholder)
                        .frame(width: 56 * s, height: max(5, 7 * s))

                    Capsule()
                        .fill(placeholder.opacity(0.65))
                        .frame(width: 36 * s, height: max(4, 5 * s))
                }
                .padding(8 * s)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color.faxenCard,
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.faxenBorder)
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct ViewModePicker: View {
    @Environment(AppTheme.self) private var theme
    var compact: Bool = false
    var axis: Axis = .horizontal

    var body: some View {
        if axis == .vertical {
            VStack(spacing: 12) {
                option(.expressive, title: "expressive")
                option(.compact, title: "compact")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        } else {
            HStack(spacing: 12) {
                option(.expressive, title: "expressive")
                option(.compact, title: "compact")
            }
        }
    }

    private func option(_ mode: ViewMode, title: String) -> some View {
        let selected = theme.viewMode == mode

        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                theme.viewMode = mode
            }
        } label: {
            VStack(spacing: 8) {
                ViewModePreview(mode: mode)
                    .frame(maxWidth: .infinity, maxHeight: axis == .vertical ? .infinity : nil)
                    .frame(minHeight: axis == .vertical ? 0 : nil)
                    .frame(height: axis == .vertical ? nil : (compact ? 150 : 210))
                    .clipped()

                Text(title)
                    .font(.system(size: 14, weight: selected ? .semibold : .medium))
                    .foregroundStyle(selected ? Color.faxenAccent : Color.faxenMuted)
            }
            .padding(6)
            .frame(maxWidth: .infinity, maxHeight: axis == .vertical ? .infinity : nil)
            .frame(minHeight: axis == .vertical ? 0 : nil)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(selected ? Color.faxenAccent : Color.clear, lineWidth: 2.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: axis == .vertical ? .infinity : nil)
        .frame(minHeight: axis == .vertical ? 0 : nil)
        .accessibilityLabel("\(title) view mode")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct SizeControl: View {
    @Environment(AppTheme.self) private var theme
    var showsPreview: Bool = true
    var compactSlider: Bool = false

    var body: some View {
        @Bindable var theme = theme

        VStack(spacing: 0) {
            if showsPreview {
                if compactSlider {
                    Spacer(minLength: 0)
                }

                ViewModePreview(mode: theme.viewMode, sizeScale: theme.sizeScale)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: compactSlider ? .infinity : 230)
                    .animation(.easeInOut(duration: 0.15), value: theme.sizeScale)

                if compactSlider {
                    Spacer(minLength: 0)
                }
            }

            VStack(spacing: 8) {
                Slider(value: $theme.sizeScale, in: AppTheme.sizeRange, step: 0.05)
                    .controlSize(.small)
                    .tint(Color.faxenAccent)
                    .accessibilityLabel("Interface size")

                HStack {
                    Text("smaller")
                    Spacer()
                    Text("larger")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.faxenMuted)
            }
            .frame(maxWidth: compactSlider ? 220 : .infinity)
            .padding(.top, compactSlider ? 12 : 16)
        }
    }
}

struct FaxenPrimaryButton: View {
    let title: String
    var scaled: Bool = true
    var action: () -> Void

    @Environment(AppTheme.self) private var theme

    var body: some View {
        let metrics = scaled ? theme.metrics : FaxenMetrics(viewMode: .expressive, scale: 1)

        Button(action: action) {
            Text(title)
                .font(.system(size: metrics.buttonFont, weight: .semibold))
                .foregroundStyle(.white)
                .frame(height: metrics.buttonHeight)
                .padding(.horizontal, metrics.buttonPadding)
                .background(Color.faxenAccent, in: Capsule())
                .shadow(color: Color(hex: 0xC2410C).opacity(0.32), radius: 16, y: 8)
        }
        .buttonStyle(.plain)
    }
}

struct FaxenSecondaryButton: View {
    let title: String
    var scaled: Bool = true
    var action: () -> Void

    @Environment(AppTheme.self) private var theme

    var body: some View {
        let metrics = scaled ? theme.metrics : FaxenMetrics(viewMode: .expressive, scale: 1)

        Button(action: action) {
            Text(title)
                .font(.system(size: metrics.buttonFont, weight: .semibold))
                .foregroundStyle(Color.faxenForeground)
                .frame(height: metrics.buttonHeight)
                .padding(.horizontal, metrics.buttonPadding)
                .background(Color.faxenCard, in: Capsule())
                .overlay(Capsule().stroke(Color.faxenBorder))
        }
        .buttonStyle(.plain)
    }
}
