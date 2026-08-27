//
//  FaxenAuthView.swift
//  faxen-ios
//
//  Created by M Fan on 2026-08-25.
//

import AuthenticationServices
import ClerkKit
import SwiftUI

struct FaxenAuthView: View {
    @Environment(Clerk.self) private var clerk
    @Environment(AppRouter.self) private var appRouter

    @State private var errorMessage: String?

    var body: some View {
        FaxenSignInForm(externalError: $errorMessage) {
            finishIfVerified()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onChange(of: clerk.user?.id) { _, newValue in
            guard newValue != nil else { return }
            finishIfVerified()
        }
        .onChange(of: clerk.session?.id) { _, _ in
            finishIfVerified()
        }
    }

    @MainActor
    private func finishIfVerified() {
        guard let user = clerk.user, clerk.session?.status == .active else { return }

        if user.isVerifiedForFaxen {
            withAnimation(.easeInOut) {
                appRouter.go(to: .dashboard)
            }
            return
        }

        Task {
            try? await clerk.auth.signOut()
            errorMessage = "Your account isn’t verified yet. Check your email for a code, then try again."
        }
    }
}

private extension User {
    var isVerifiedForFaxen: Bool {
        hasVerifiedEmailAddress
            || hasVerifiedPhoneNumber
            || !verifiedExternalAccounts.isEmpty
    }
}

private enum FaxenAuthMode: String, CaseIterable {
    case signIn = "sign in"
    case signUp = "create account"
}

private enum FaxenAuthStep: Equatable {
    case credentials
    case verifyEmail
}

private struct FaxenSignInForm: View {
    @Environment(Clerk.self) private var clerk
    @Environment(\.colorScheme) private var colorScheme

    @Binding var externalError: String?
    var onAuthenticated: () -> Void

    @State private var mode: FaxenAuthMode = .signIn
    @State private var step: FaxenAuthStep = .credentials
    @State private var email = ""
    @State private var password = ""
    @State private var code = ""
    @State private var isSecure = true
    @State private var isLoading = false
    @State private var localError: String?
    @State private var pendingSignIn: SignIn?
    @State private var pendingSignUp: SignUp?
    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password, code
    }

    private var errorMessage: String? {
        localError ?? externalError
    }

    var body: some View {
        VStack(spacing: 0) {
            brandHeader
                .padding(.bottom, 16)

            VStack(spacing: 16) {
                modePicker

                Group {
                    switch step {
                    case .credentials:
                        credentialsContent
                    case .verifyEmail:
                        verifyContent
                    }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.faxenAccent)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(18)
            .background(panelBackground, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.faxenBorder)
            )

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var brandHeader: some View {
        VStack(spacing: 14) {
            FoxLockup(size: 72)

            Text("faxen")
                .font(.system(size: 28, weight: .regular, design: .serif))
                .foregroundStyle(Color.faxenForeground)
                .tracking(-0.4)
        }
        .frame(maxWidth: .infinity)
    }

    private var panelBackground: some ShapeStyle {
        colorScheme == .dark
            ? AnyShapeStyle(Color(hex: 0x1C1917).opacity(0.38))
            : AnyShapeStyle(Color.white.opacity(0.28))
    }

    private var modePicker: some View {
        HStack(spacing: 4) {
            ForEach(FaxenAuthMode.allCases, id: \.self) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        mode = option
                        step = .credentials
                        code = ""
                        clearErrors()
                        pendingSignIn = nil
                        pendingSignUp = nil
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.system(size: 13, weight: mode == option ? .semibold : .medium))
                        .foregroundStyle(mode == option ? Color.faxenAccent : Color.faxenMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            mode == option
                                ? Color.faxenAccent.opacity(colorScheme == .dark ? 0.18 : 0.10)
                                : Color.clear,
                            in: Capsule()
                        )
                        .overlay(
                            Capsule()
                                .stroke(mode == option ? Color.faxenAccent.opacity(0.35) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.faxenForeground.opacity(colorScheme == .dark ? 0.08 : 0.04), in: Capsule())
    }

    private var credentialsContent: some View {
        VStack(spacing: 12) {
            FaxenTextField(
                title: "email",
                text: $email,
                contentType: .emailAddress,
                keyboardType: .emailAddress,
                isFocused: focusedField == .email
            )
            .focused($focusedField, equals: .email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.next)
            .onSubmit { focusedField = .password }

            FaxenSecureField(
                title: "password",
                text: $password,
                isSecure: $isSecure,
                isFocused: focusedField == .password
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.go)
            .onSubmit { submitCredentials() }

            FaxenAuthPrimaryButton(
                title: mode == .signIn ? "continue" : "create account",
                isLoading: isLoading
            ) {
                submitCredentials()
            }
            .disabled(isLoading || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty)
            .opacity(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty ? 0.55 : 1)

            FaxenAuthDivider(text: "or continue with")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                FaxenAppleButton(isLoading: isLoading) {
                    Task { await signInWithApple() }
                }

                ForEach([OAuthProvider.google, .github, .microsoft], id: \.self) { provider in
                    FaxenOAuthButton(provider: provider, isLoading: isLoading) {
                        Task { await signInWithOAuth(provider) }
                    }
                }
            }
            .disabled(isLoading)
        }
    }

    private var verifyContent: some View {
        VStack(spacing: 12) {
            Text("enter the code we sent to \(email.trimmingCharacters(in: .whitespacesAndNewlines))")
                .font(.system(size: 14))
                .foregroundStyle(Color.faxenMuted)
                .multilineTextAlignment(.center)

            FaxenTextField(
                title: "verification code",
                text: $code,
                contentType: .oneTimeCode,
                keyboardType: .numberPad,
                isFocused: focusedField == .code
            )
            .focused($focusedField, equals: .code)

            FaxenAuthPrimaryButton(title: "verify", isLoading: isLoading) {
                Task { await verifyCode() }
            }
            .disabled(isLoading || code.trimmingCharacters(in: .whitespacesAndNewlines).count < 4)
            .opacity(code.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 ? 0.55 : 1)

            Button {
                withAnimation(.easeInOut) {
                    step = .credentials
                    code = ""
                    clearErrors()
                }
            } label: {
                Text("use a different email")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.faxenMuted)
            }
            .buttonStyle(.plain)
            .disabled(isLoading)
        }
    }

    private func submitCredentials() {
        focusedField = nil
        Task {
            if mode == .signIn {
                await signIn()
            } else {
                await signUp()
            }
        }
    }

    @MainActor
    private func signIn() async {
        await run {
            let signIn = try await clerk.auth.signInWithPassword(
                identifier: normalizedEmail,
                password: password
            )
            try await continueSignIn(signIn)
        }
    }

    @MainActor
    private func signUp() async {
        await run {
            var signUp = try await clerk.auth.signUp(
                emailAddress: normalizedEmail,
                password: password
            )

            if signUp.status == .complete {
                onAuthenticated()
                return
            }

            if signUp.unverifiedFields.contains(.emailAddress) {
                signUp = try await signUp.sendEmailCode()
                pendingSignUp = signUp
                pendingSignIn = nil
                withAnimation(.easeInOut) {
                    step = .verifyEmail
                }
                return
            }

            throw FaxenAuthError("We still need a few more details before this account is ready.")
        }
    }

    @MainActor
    private func verifyCode() async {
        await run {
            let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)

            if var signIn = pendingSignIn {
                signIn = try await signIn.verifyCode(trimmed)
                try await continueSignIn(signIn)
                return
            }

            if var signUp = pendingSignUp {
                signUp = try await signUp.verifyEmailCode(trimmed)
                if signUp.status == .complete {
                    pendingSignUp = nil
                    onAuthenticated()
                    return
                }

                if signUp.unverifiedFields.contains(.emailAddress) {
                    pendingSignUp = signUp
                    throw FaxenAuthError("That code didn’t work. Double-check it and try again.")
                }

                throw FaxenAuthError("Your account still needs a couple more steps before it’s ready.")
            }

            throw FaxenAuthError("There’s nothing to verify right now. Go back and try signing in again.")
        }
    }

    @MainActor
    private func signInWithApple() async {
        await run {
            _ = try await clerk.auth.signInWithApple()
            onAuthenticated()
        }
    }

    @MainActor
    private func signInWithOAuth(_ provider: OAuthProvider) async {
        await run {
            _ = try await clerk.auth.signInWithOAuth(provider: provider)
            onAuthenticated()
        }
    }

    @MainActor
    private func continueSignIn(_ signIn: SignIn) async throws {
        switch signIn.status {
        case .complete:
            pendingSignIn = nil
            pendingSignUp = nil
            onAuthenticated()
        case .needsFirstFactor:
            let next = try await signIn.sendEmailCode()
            pendingSignIn = next
            pendingSignUp = nil
            withAnimation(.easeInOut) {
                step = .verifyEmail
            }
        default:
            pendingSignIn = signIn
            throw FaxenAuthError("This account needs another security step we don’t support here yet.")
        }
    }

    private var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func clearErrors() {
        localError = nil
        externalError = nil
    }

    @MainActor
    private func run(_ work: () async throws -> Void) async {
        isLoading = true
        clearErrors()
        defer { isLoading = false }

        do {
            try await work()
        } catch {
            localError = FaxenAuthError.friendlyMessage(for: error)
        }
    }
}

private struct FaxenAuthError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? { message }

    static func friendlyMessage(for error: Error) -> String {
        if let authError = error as? FaxenAuthError {
            return authError.message
        }

        if let apiError = error as? ClerkAPIError {
            if let mapped = map(code: apiError.code) {
                return mapped
            }
            if let longMessage = apiError.longMessage, !longMessage.isEmpty {
                return plainEnglish(longMessage)
            }
            if let message = apiError.message, !message.isEmpty {
                return plainEnglish(message)
            }
        }

        if let clientError = error as? ClerkClientError,
           let message = clientError.message,
           !message.isEmpty {
            return plainEnglish(message)
        }

        return plainEnglish(error.localizedDescription)
    }

    private static func map(code: String) -> String? {
        switch code {
        case "form_identifier_not_found",
             "form_password_incorrect",
             "strategy_for_user_invalid":
            return "That email or password doesn’t look right."
        case "form_identifier_exists",
             "form_username_exists",
             "form_param_exists":
            return "An account with that email already exists. Try signing in instead."
        case "form_password_pwned":
            return "Please choose a stronger password. That one has shown up in known data breaches."
        case "form_password_length_too_short":
            return "Your password is too short. Try something a bit longer."
        case "form_code_incorrect",
             "verification_failed",
             "form_param_format_invalid":
            return "That code didn’t work. Double-check it and try again."
        case "verification_expired":
            return "That code expired. Go back and request a new one."
        case "too_many_requests",
             "rate_limit_exceeded":
            return "Too many attempts. Wait a moment and try again."
        case "oauth_access_denied",
             "oauth_identification_claimed":
            return "That sign-in was cancelled or couldn’t be completed."
        case "session_exists":
            return "You’re already signed in."
        default:
            return nil
        }
    }

    private static func plainEnglish(_ raw: String) -> String {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = text.lowercased()

        if lower.contains("cancel") {
            return "Sign in was cancelled."
        }
        if lower.contains("network") || lower.contains("offline") || lower.contains("internet") {
            return "We couldn’t reach the server. Check your connection and try again."
        }
        if lower.contains("password") && (lower.contains("incorrect") || lower.contains("invalid")) {
            return "That email or password doesn’t look right."
        }
        if lower.contains("identifier") && lower.contains("not found") {
            return "We couldn’t find an account with that email."
        }
        if lower.contains("already") && lower.contains("exist") {
            return "An account with that email already exists. Try signing in instead."
        }
        if text.isEmpty {
            return "Something went wrong. Please try again."
        }
        return text
    }
}

private struct FaxenTextField: View {
    let title: String
    @Binding var text: String
    var contentType: UITextContentType?
    var keyboardType: UIKeyboardType = .default
    var isFocused: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.faxenMuted)
                .textCase(.lowercase)

            TextField("", text: $text)
                .font(.system(size: 16))
                .foregroundStyle(Color.faxenForeground)
                .textContentType(contentType)
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(
                    colorScheme == .dark ? Color.black.opacity(0.22) : Color.white.opacity(0.55),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isFocused ? Color.faxenAccent : Color.faxenBorder, lineWidth: isFocused ? 1.5 : 1)
                )
        }
    }
}

private struct FaxenSecureField: View {
    let title: String
    @Binding var text: String
    @Binding var isSecure: Bool
    var isFocused: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.faxenMuted)
                .textCase(.lowercase)

            HStack(spacing: 8) {
                Group {
                    if isSecure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .font(.system(size: 16))
                .foregroundStyle(Color.faxenForeground)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.faxenMuted)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(
                colorScheme == .dark ? Color.black.opacity(0.22) : Color.white.opacity(0.55),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isFocused ? Color.faxenAccent : Color.faxenBorder, lineWidth: isFocused ? 1.5 : 1)
            )
        }
    }
}

private struct FaxenAuthPrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.faxenAccent, in: Capsule())
            .shadow(color: Color(hex: 0xC2410C).opacity(0.28), radius: 14, y: 8)
        }
        .buttonStyle(.plain)
    }
}

private struct FaxenAuthDivider: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.faxenBorder)
                .frame(height: 1)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.faxenMuted)
                .fixedSize()
            Rectangle()
                .fill(Color.faxenBorder)
                .frame(height: 1)
        }
        .padding(.vertical, 2)
    }
}

private struct FaxenAppleButton: View {
    var isLoading: Bool
    var action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 18, weight: .medium))
                Text("apple")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(Color.faxenForeground)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                colorScheme == .dark ? Color.black.opacity(0.22) : Color.white.opacity(0.55),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.faxenBorder)
            )
            .opacity(isLoading ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continue with Apple")
    }
}

private struct FaxenOAuthButton: View {
    let provider: OAuthProvider
    var isLoading: Bool
    var action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                providerIcon
                    .frame(width: 18, height: 18)

                Text(provider.name.lowercased())
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(Color.faxenForeground)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                colorScheme == .dark ? Color.black.opacity(0.22) : Color.white.opacity(0.55),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.faxenBorder)
            )
            .opacity(isLoading ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Continue with \(provider.name)")
    }

    @ViewBuilder
    private var providerIcon: some View {
        if let url = provider.iconImageUrl {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .saturation(provider.supportsTintedIconMask ? 0 : 1)
                        .opacity(provider.supportsTintedIconMask ? 0.9 : 1)
                default:
                    fallbackIcon
                }
            }
        } else {
            fallbackIcon
        }
    }

    private var fallbackIcon: some View {
        Image(systemName: fallbackSymbol)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.faxenForeground)
    }

    private var fallbackSymbol: String {
        switch provider {
        case .google: "g.circle"
        case .github: "chevron.left.forwardslash.chevron.right"
        case .microsoft: "square.grid.2x2"
        default: "person.crop.circle"
        }
    }
}

#Preview {
    ZStack {
        FaxenBackground()
        FaxenAuthView()
            .padding(20)
    }
    .previewAppEnvironment()
}
