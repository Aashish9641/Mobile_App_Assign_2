import Foundation
import CoreData

extension Student {
    static func countInDatabase(context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<Student>(entityName: "Student")
        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
}

extension Course {
    static func countInDatabase(context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<Course>(entityName: "Course")
        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
}
