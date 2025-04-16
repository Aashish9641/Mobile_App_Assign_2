import SwiftUI //importing the switf UI for framework

@main // Main entry point of the app
struct AttendanceApp: App { // App name called attendance
    @StateObject var authVM = AuthViewModel() // make the instance of Auth view model as a object state
    let persistenceController = PersistenceController.shared // Access the shared instance of core data stack
    
    init() { // when  the app begins initializer calls
        print("Entities of Core data:", PersistenceController.shared.container.managedObjectModel.entitiesByName.keys) // printing the core data entitiies in the model for debugging
    }
    
    var body: some Scene { // main body scene page
        WindowGroup {
            ContentView() // setting the root view of app to content view
                .environmentObject(authVM) // add injecting the authentication view model
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // Setting or injecting the core data context to the envgiroment so it can be accessed by viewers
        }
    }
}
