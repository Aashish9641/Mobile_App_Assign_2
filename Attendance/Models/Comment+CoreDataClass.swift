import Foundation // using import foundation and basic like date
import CoreData // Importing the core data framework for management of database

@objc(Comment) // Defining the core data entity, comment and make it in runtime
public class Comment: NSManagedObject, Identifiable { // Management of NSmanageobject
    @NSManaged public var id: UUID // unique id for the comment part
    @NSManaged public var content: String // string context for comment
    @NSManaged public var timestamp: Date // when the comment was build and add date and time
    @NSManaged public var author: Student? // adding the author for studnets
    @NSManaged public var post: Post? // post for comments who belongs to

    // Using the class make the fetch request for the comment entity
@nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
    return NSFetchRequest<Comment>(entityName: "Comment") //comment name delcaing the entity
}
}
