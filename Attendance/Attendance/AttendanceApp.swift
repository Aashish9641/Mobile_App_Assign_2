import SwiftUI

@main
struct AttendanceApp: App {
    @StateObject var authVM = AuthViewModel()
    let persistenceController = PersistenceController.shared
    
    init() {
        print("Core Data Entities:", PersistenceController.shared.container.managedObjectModel.entitiesByName.keys)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
