import Foundation
import CoreData

@objc(Student)
class Student: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var profilePicture: Data?
    @NSManaged var course: Course?
    @NSManaged var attendanceRecords: NSSet?
    @NSManaged var posts: NSSet?
}

@objc(Course)
class Course: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var students: NSSet?
}

@objc(Attendance)
class Attendance: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var student: Student?
    @NSManaged var status: Bool
}

@objc(Post)
class Post: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var content: String
    @NSManaged var timestamp: Date
    @NSManaged var author: Student?
    @NSManaged var isGlobal: Bool
}
