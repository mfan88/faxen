//
//  FoxMark.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI

struct FoxMark: View {
    var color: Color = .white

    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height) / 24
            let stroke = StrokeStyle(
                lineWidth: 1.55 * scale,
                lineCap: .round,
                lineJoin: .round
            )

            var head = Path()
            head.move(to: point(6.3, 10.7, scale: scale))
            head.addLine(to: point(9, 3.4, scale: scale))
            head.addLine(to: point(12, 9.1, scale: scale))
            head.addLine(to: point(15, 3.4, scale: scale))
            head.addLine(to: point(17.7, 10.7, scale: scale))
            head.addLine(to: point(20.4, 13.5, scale: scale))
            head.addLine(to: point(17.4, 20.2, scale: scale))
            head.addLine(to: point(12, 21.4, scale: scale))
            head.addLine(to: point(6.6, 20.2, scale: scale))
            head.addLine(to: point(3.6, 13.5, scale: scale))
            head.closeSubpath()
            context.stroke(head, with: .color(color), style: stroke)

            var ears = Path()
            ears.move(to: point(9.4, 8.5, scale: scale))
            ears.addLine(to: point(10.3, 5.8, scale: scale))
            ears.move(to: point(13.7, 5.8, scale: scale))
            ears.addLine(to: point(14.6, 8.5, scale: scale))
            context.stroke(ears, with: .color(color), style: stroke)

            var snout = Path()
            snout.move(to: point(10.45, 16.15, scale: scale))
            snout.addLine(to: point(12, 18.2, scale: scale))
            snout.addLine(to: point(13.55, 16.15, scale: scale))
            context.stroke(snout, with: .color(color), style: stroke)

            let eyeRadius: CGFloat = 0.7 * scale
            context.fill(
                Path(ellipseIn: CGRect(
                    x: 10.2 * scale - eyeRadius,
                    y: 13.35 * scale - eyeRadius,
                    width: eyeRadius * 2,
                    height: eyeRadius * 2
                )),
                with: .color(color)
            )
            context.fill(
                Path(ellipseIn: CGRect(
                    x: 13.8 * scale - eyeRadius,
                    y: 13.35 * scale - eyeRadius,
                    width: eyeRadius * 2,
                    height: eyeRadius * 2
                )),
                with: .color(color)
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }

    private func point(_ x: CGFloat, _ y: CGFloat, scale: CGFloat) -> CGPoint {
        CGPoint(x: x * scale, y: y * scale)
    }
}

struct FoxLockup: View {
    var size: CGFloat = 36

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let markSize = size * (24 / 36)
        let corner = size * (12 / 36)
        let shadow = size * (12 / 36)

        FoxMark(color: colorScheme == .dark ? Color(hex: 0x111111) : .white)
            .frame(width: markSize, height: markSize)
            .frame(width: size, height: size)
            .background(Color.faxenAccent, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
            .shadow(color: Color(hex: 0xC2410C).opacity(0.28), radius: shadow, y: shadow / 2)
            .accessibilityHidden(true)
    }
}
