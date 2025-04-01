// MARK: - 📂 Models/Course+CoreDataClass.swift
import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var code: String
    @NSManaged public var schedule: String
    @NSManaged public var students: Set<Student>?
    @NSManaged public var posts: Set<Post>?
    @NSManaged public var attendanceRecords: Set<Attendance>?
}
