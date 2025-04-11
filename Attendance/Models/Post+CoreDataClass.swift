import Foundation //Importing the foundation for basic part like date, string
import CoreData // importing the coredata for managing the database

@objc(Post) // marking this data as core data entity post
// management of the core data entity using NSmanaged
public class Post: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID // using id for post
    @NSManaged public var content: String //text for the post
    @NSManaged public var timestamp: Date // data and time when the post was made
    @NSManaged public var isGlobal: Bool  // added boolean flag to find out if the post is particular group
    @NSManaged public var author: Student? // for authorizied studnet for the post
    @NSManaged public var course: Course? // course realted to the post
    @NSManaged public var comments: Set<Comment>? // adding the set of comments linked to the post
    
    // computed property trhat returns the timestamp for shorting date and time
    public var dateFor: String {
        let forMa = DateFormatter() // make a date formatter instance
        forMa.dateStyle = .short // fix the date style to short
        forMa.timeStyle = .short // setting to time style
        return forMa.string(from: timestamp) // returing the formatted string
    }
    // adding the class object that make fetch request fgor the post in coredata
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post") // adding the post entitiy
    }
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }
}
