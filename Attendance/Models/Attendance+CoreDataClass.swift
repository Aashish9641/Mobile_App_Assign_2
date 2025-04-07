// MARK: - 📂 Models/Attendance+CoreDataClass.swift
import Foundation
import CoreData

@objc(Attendance)
public class Attendance: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var status: String
    @NSManaged public var student: Student?
    @NSManaged public var course: Course?
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }
}
