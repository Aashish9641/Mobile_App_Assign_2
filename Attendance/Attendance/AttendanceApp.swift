//
//  AttendanceApp.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import SwiftUI

@main
struct AttendanceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
