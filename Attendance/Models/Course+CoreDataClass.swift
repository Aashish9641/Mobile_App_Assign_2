import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var schedule: String?
    @NSManaged public var students: NSSet?
    
    // Sorted students array
    public var studentsArray: [Student] {
        let set = students as? Set<Student> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // Safe method to add a student to the course
    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)
    
    // Safe method to remove a student from the course
    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)
    
    // Core Data fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }
}
