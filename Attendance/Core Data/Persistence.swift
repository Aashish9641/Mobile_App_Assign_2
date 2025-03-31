import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "StudentsApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Create default admin if needed
        createDefaultAdmin()
    }
    
    private func createDefaultAdmin() {
        let context = container.viewContext
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.predicate = NSPredicate(format: "isAdmin == true")
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                let admin = Student(context: context)
                admin.id = UUID()
                admin.name = "Admin"
                admin.email = "admin@grace.edu"
                admin.password = "admin123"
                admin.isAdmin = true
                try context.save()
            }
        } catch {
            print("Error creating admin: \(error)")
        }
    }
}
