//
//  faxenApp.swift
//  faxen
//
//  Created by M Fan on 2026-08-25.
//

import SwiftUI
import SwiftData
import ClerkKit

@main
struct faxenApp: App {
    @State private var appRouter = AppRouter()
    @State private var theme = AppTheme()
    @State private var screenRouter = ScreenRouter()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init(){
        Clerk.configure(publishableKey: "pk_test_bWF0dXJlLW1vbmtleS05NjMwLmNsZXJrLmFjY291bnRzLmRldiQ")
    }

    var body: some Scene {
        WindowGroup {
            ViewManager()
                .environment(appRouter)
                .environment(screenRouter)
                .environment(theme)
                .environment(Clerk.shared)
                .onOpenURL { url in
                    Task {
                        try? await Clerk.shared.handle(url)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
