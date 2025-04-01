// MARK: - 📂 Models/Post+CoreDataClass.swift
import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var timestamp: Date
    @NSManaged public var isGlobal: Bool
    @NSManaged public var author: Student?
    @NSManaged public var course: Course?
    @NSManaged public var comments: Set<Comment>?
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
