//
//  FaxenTheme.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    init(light: Color, dark: Color) {
        self.init(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
            }
        )
    }

    static let faxenBackground = Color(light: Color(hex: 0xF6F3EE), dark: Color(hex: 0x161311))
    static let faxenForeground = Color(light: Color(hex: 0x1C1917), dark: Color(hex: 0xF4EFE9))
    static let faxenMuted = Color(light: Color(hex: 0x78716C), dark: Color(hex: 0xA8A29E))
    static let faxenAccent = Color(light: Color(hex: 0xC2410C), dark: Color(hex: 0xEA580C))
    static let faxenCard = Color(
        light: Color.white.opacity(0.52),
        dark: Color(hex: 0x1C1917).opacity(0.42)
    )
    static let faxenBorder = Color(
        light: Color(hex: 0x1C1917).opacity(0.08),
        dark: Color(hex: 0xF4EFE9).opacity(0.10)
    )
    static let faxenIconWell = Color(
        light: Color.white.opacity(0.70),
        dark: Color(hex: 0x1C1917).opacity(0.70)
    )
}

enum ViewMode: String, CaseIterable, Hashable {
    case expressive
    case compact
}

struct FaxenMetrics {
    var viewMode: ViewMode
    var scale: Double

    var logoSize: CGFloat { value(expressive: 128, compact: 72) }
    var titleFont: CGFloat { value(expressive: 26, compact: 20) }
    var bodyFont: CGFloat { value(expressive: 16, compact: 14) }
    var buttonFont: CGFloat { value(expressive: 15, compact: 13) }
    var buttonHeight: CGFloat { value(expressive: 48, compact: 38) }
    var buttonPadding: CGFloat { value(expressive: 28, compact: 18) }
    var spacing: CGFloat { value(expressive: 28, compact: 16) }
    var sectionPadding: CGFloat { value(expressive: 20, compact: 12) }
    var cornerRadius: CGFloat { value(expressive: 16, compact: 10) }

    private func value(expressive: Double, compact: Double) -> CGFloat {
        CGFloat((viewMode == .expressive ? expressive : compact) * scale)
    }
}

@Observable
final class AppTheme {
    var isDark: Bool {
        didSet { UserDefaults.standard.set(isDark ? "dark" : "light", forKey: Self.themeKey) }
    }

    var viewMode: ViewMode {
        didSet { UserDefaults.standard.set(viewMode.rawValue, forKey: Self.viewModeKey) }
    }

    var sizeScale: Double {
        didSet { UserDefaults.standard.set(sizeScale, forKey: Self.sizeKey) }
    }

    var colorScheme: ColorScheme {
        isDark ? .dark : .light
    }

    var metrics: FaxenMetrics {
        FaxenMetrics(viewMode: viewMode, scale: sizeScale)
    }

    static let sizeRange = 0.8...1.3

    private static let themeKey = "faxen.theme"
    private static let viewModeKey = "faxen.viewMode"
    private static let sizeKey = "faxen.sizeScale"

    init() {
        switch UserDefaults.standard.string(forKey: Self.themeKey) {
        case "dark":
            isDark = true
        case "light":
            isDark = false
        default:
            isDark = UITraitCollection.current.userInterfaceStyle == .dark
        }

        viewMode = ViewMode(rawValue: UserDefaults.standard.string(forKey: Self.viewModeKey) ?? "") ?? .expressive

        if let stored = UserDefaults.standard.object(forKey: Self.sizeKey) as? Double {
            sizeScale = min(max(stored, Self.sizeRange.lowerBound), Self.sizeRange.upperBound)
        } else {
            sizeScale = 1
        }
    }

    func toggle() {
        isDark.toggle()
    }
}

struct FaxenBackground: View {
    var ignoresSafeArea: Bool = true
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let isDark = colorScheme == .dark

        let fill = ZStack {
            Color.faxenBackground

            RadialGradient(
                colors: isDark
                    ? [Color(hex: 0xC2410C).opacity(0.42), Color(hex: 0x9A3412).opacity(0.20), .clear]
                    : [Color.white, Color(hex: 0xFFF8F1).opacity(0.90), .clear],
                center: UnitPoint(x: 0.5, y: -0.08),
                startRadius: 20,
                endRadius: 520
            )

            RadialGradient(
                colors: isDark
                    ? [Color(hex: 0x7F1D1D).opacity(0.38), Color(hex: 0x44403C).opacity(0.18), .clear]
                    : [Color(hex: 0xFFEDD5).opacity(0.72), .clear],
                center: UnitPoint(x: 0.92, y: 0.12),
                startRadius: 8,
                endRadius: 280
            )

            RadialGradient(
                colors: isDark
                    ? [Color(hex: 0x57534E).opacity(0.50), Color(hex: 0x292524).opacity(0.32), .clear]
                    : [Color(hex: 0xFFFAF4).opacity(0.90), Color(hex: 0xFEF3E2).opacity(0.40), .clear],
                center: UnitPoint(x: 0.06, y: 0.96),
                startRadius: 8,
                endRadius: 320
            )

            RadialGradient(
                colors: isDark
                    ? [Color(hex: 0xEA580C).opacity(0.16), .clear]
                    : [Color.white.opacity(0.85), .clear],
                center: UnitPoint(x: 0.5, y: 0.50),
                startRadius: 4,
                endRadius: 180
            )
        }

        if ignoresSafeArea {
            fill.ignoresSafeArea()
        } else {
            fill
        }
    }
}

struct ThemeToggle: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.3)) {
                theme.toggle()
            }
        } label: {
            ZStack {
                Capsule()
                    .fill(theme.isDark ? Color(hex: 0x0C0A09).opacity(0.50) : Color.white.opacity(0.60))
                    .overlay(
                        Capsule()
                            .stroke(
                                theme.isDark ? Color.white.opacity(0.10) : Color(hex: 0x1C1917).opacity(0.10)
                            )
                    )

                HStack(spacing: 0) {
                    if theme.isDark { Spacer(minLength: 0) }
                    knob
                    if !theme.isDark { Spacer(minLength: 0) }
                }
                .padding(4)

                HStack(spacing: 0) {
                    Image(systemName: "sun.max")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(theme.isDark ? Color(hex: 0x78716C) : Color(hex: 0x44403C))
                    Image(systemName: "moon")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(theme.isDark ? Color(hex: 0xFED7AA) : Color(hex: 0xA8A29E))
                }
                .font(.system(size: 13, weight: .medium))
            }
            .frame(width: 68, height: 40)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Toggle color theme")
    }

    private var knob: some View {
        Circle()
            .fill(theme.isDark ? Color(hex: 0x1C1917) : Color.white)
            .frame(width: 32, height: 32)
            .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
    }
}
