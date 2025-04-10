import Foundation
import CoreData

@objc(Student)
public class Student: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var courses: NSSet?
    
    // Sorted courses array
    public var coursesArray: [Course] {
        let set = courses as? Set<Course> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // Safe method to add a course
    public func safeAddCourse(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait {
            print("Attempting to add course: \(course.name ?? "Unknown") to student: \(name ?? "Unknown")")
            
            if let coursesSet = courses as? NSMutableSet, !coursesSet.contains(course) {
                coursesSet.add(course)
                course.addToStudents(self)
                print("Successfully added course: \(course.name ?? "Unknown") to student: \(name ?? "Unknown")")
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                }
            } else {
                print("Course already exists for this student or invalid set.")
            }
        }
    }
    
    // Safe method to remove a course
    public func safeRemoveCourse(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait {
            print("Attempting to remove course: \(course.name ?? "Unknown") from student: \(name ?? "Unknown")")
            
            if let coursesSet = courses as? NSMutableSet, coursesSet.contains(course) {
                coursesSet.remove(course)
                course.removeFromStudents(self)
                print("Successfully removed course: \(course.name ?? "Unknown") from student: \(name ?? "Unknown")")
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                }
            } else {
                print("Course not found in this student's courses.")
            }
        }
    }
    
    // Core Data fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }
}
