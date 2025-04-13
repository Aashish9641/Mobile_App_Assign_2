import SwiftUI // importing the swift UI for UIUX
import CoreData // Management of the database

class PostViewModel: ObservableObject { // view model for handling post creating and retrivial
    // Accessing the core data context for management of the entities
    private let tecxCon = PersistenceController.shared.container.viewContext
    
    // add function to make the new post
    func makePos(content: String, isGlobal: Bool, course: Course?, author: Student) {
        let post = Post(context: tecxCon) // make the new post context
        post.id = UUID() // Assigend the unique ID to the post
        post.content = content // adding the content of the post
        post.timestamp = Date() // setting the current time as timestamp
        post.isGlobal = isGlobal //indicate whether the post or course
        post.author = author //fixing the author of the post
        post.course = course // linking the post to teh courses
        PersistenceController.shared.save() // saving the latest post to the database
    }
    //Add the post for fetching (global or particluar post)
    func postGets(for course: Course? = nil) -> [Post] {
        let request = NSFetchRequest<Post>(entityName: "Post") // make the fetch request from the database
        if let course = course { // adding the predicate based if the particluar course was given
            request.predicate = NSPredicate(format: "course == %@", course)
        } else { // fetching course from belonging course
            request.predicate = NSPredicate(format: "isGlobal == true") // if the course is not valid then it will fetch the global post
        }
        // sorting the posts by time in the order of decending
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        // function to handling error
        do {
            return try tecxCon.fetch(request) // trying the fetching post from database
        } catch {
            print("Issue in  fetching posts: \(error)") // throw error while issue in fetching
            return [] // returing the null arrya
        }
    }
}
