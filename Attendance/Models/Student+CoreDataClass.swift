import Foundation
import CoreData

@objc(Student)
public class Student: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var courses: NSSet?
    
    public var coursesArray: [Course] {
        let set = courses as? Set<Course> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)
    
    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)
    
    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)
    
    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)
    
    public func safeAddCourse(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait {
            if !coursesArray.contains(course) {
                addToCourses(course)
                course.addToStudents(self)
            }
        }
    }
    
    public func safeRemoveCourse(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait {
            removeFromCourses(course)
            course.removeFromStudents(self)
        }
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }
}
