// MARK: - Models/Student+CoreDataClass.swift
import Foundation
import CoreData

@objc(Student)
public class Student: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var posts: Set<Post>?
    @NSManaged public var comments: Set<Comment>?
    @NSManaged public var courses: Set<Course>?
    @NSManaged public var attendanceRecords: Set<Attendance>?

    
    public func enroll(in course: Course) {
        self.mutableSetValue(forKey: "courses").add(course)
    }
}
