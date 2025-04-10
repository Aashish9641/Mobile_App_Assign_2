import Foundation
import CoreData

extension Student {
    static func countInDatabase(context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest<Student>(entityName: "Student")
        request.entity = Student.entity() // Add this line

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
        request.entity = Course.entity() // Add this line
        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
}
