<<<<<<< HEAD
import Foundation //importing the foundation to provide the basic class
import CoreData // importing coredata to management the database
=======
import Foundation
import CoreData
>>>>>>> 2a48ba131fd0c861e3c1aa78510abad6e731a2c7

// marking the class as comparebale weith object C
@objc(Course)
// management of NSmanagement of object
public class Course: NSManagedObject, Identifiable {
<<<<<<< HEAD
    @NSManaged public var id: UUID // id of uniqueness for each course
    @NSManaged public var name: String? // making the name of course in database
    @NSManaged public var code: String? // adding teh course code
    @NSManaged public var schedule: String? // adding the course schedule
    @NSManaged public var students: NSSet? //set of students added in the course
    
    // property that converts the Nset of studnets inopt swift array
    public var sArray: [Student] {
        let set = students as? Set<Student> ?? [] // saftey cast the Nseet the swift part
        return set.sorted { $0.name ?? "" < $1.name ?? "" } // sorting the studnets alphabetic
    }
    
    // adding the students to the course using safe method
    @objc(addStudentsObject:)
    @NSManaged public func plustStu(_ value: Student) // declareing the students
    
    // removing the students from course using safe method
    @objc(removeStudentsObject:)
    @NSManaged public func deltoStu(_ value: Student) // declaring the students from course
    
    // using the class method that return fetch request in core data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course") // declear the entitiy name 
    }
=======
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var code: String
    @NSManaged public var schedule: String
    @NSManaged public var students: Set<Student>?
    @NSManaged public var posts: Set<Post>?
    @NSManaged public var attendanceRecords: Set<Attendance>?
    
    // Add class method
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

>>>>>>> 2a48ba131fd0c861e3c1aa78510abad6e731a2c7
}
