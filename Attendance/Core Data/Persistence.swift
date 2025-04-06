import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Attendance")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("""
                🔥 Core Data Error:
                - Model Entities: \(self.container.managedObjectModel.entitiesByName.keys)
                - Error: \(error.localizedDescription)
                """)
            }
            print("✅ Core Data initialized with entities:", self.container.managedObjectModel.entitiesByName.keys)
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("💥 Save error: \(error.localizedDescription)")
            context.rollback()
        }
    }
}
