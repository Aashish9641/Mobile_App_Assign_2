// MARK: - 📂 Models/Comment+CoreDataClass.swift
import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var timestamp: Date
    @NSManaged public var author: Student?
    @NSManaged public var post: Post?

@nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
    return NSFetchRequest<Comment>(entityName: "Comment")
}
}
