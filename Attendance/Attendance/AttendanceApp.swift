// MARK: - AttendanceApp.swift
import SwiftUI

@main
struct AttendanceApp: App {
    @StateObject var authVM = AuthViewModel() // Create the view model
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM) // Inject the view model
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
