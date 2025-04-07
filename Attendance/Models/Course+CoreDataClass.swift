import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var schedule: String?
    @NSManaged public var students: NSSet?
    
    public var studentsArray: [Student] {
        let set = students as? Set<Student> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)
    
    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)
    
    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)
    
    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }
}
