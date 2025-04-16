import CoreData // Importing the core data framework

final class PersistenceController { // final class pressistance not a sub class
    static let shared = PersistenceController() // shared static instance for global access point
    
    let container: NSPersistentContainer // NSpresistance manage to core data
    
    init() { // inilializer core data
        container = NSPersistentContainer(name: "Attendance") //inilizier the preseistance with the model name called attendance
        container.loadPersistentStores { (storeDescription, error) in // loading the file
            if let error = error as NSError? { // error contorlling
                fatalError("""
                 Error for core Data:
                - Model Entities: \(self.container.managedObjectModel.entitiesByName.keys)
                - Error: \(error.localizedDescription)
                """)// when crash the app show this issue or infor for debugging
            }
            print("Core Data Executed with entities:",  self.container.managedObjectModel.entitiesByName.keys) // print the message like this when it sucessful
            
        }
        container.viewContext.automaticallyMergesChangesFromParent = true //auto merge change from another context as well
    }
    
    func save() { // function to save core data
        let context = container.viewContext // getting the core or main part
        guard context.hasChanges else { return } // only proceed if there are any changes
        
        do {
            try context.save() // trying to save in core data
        } catch {
            print(" Saving error: \(error.localizedDescription)") // if it fails to save then show this issue message
            context.rollback() // rolling back into the context
        }
    }
}
