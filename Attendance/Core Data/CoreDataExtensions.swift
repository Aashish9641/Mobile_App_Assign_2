import Foundation // importing the foundation lie basic function, types and collection
import CoreData // managing the core data

extension Student { // declare teh extension of student
    static func dbaData(context: NSManagedObjectContext) -> Int { // using teh static method to count no of studnets
        let request = NSFetchRequest<Student>(entityName: "Student") // fetching request for the student entity
        request.entity = Student.entity() // setting the entity for the request

        do {
            return try context.count(for: request) // trying to count the no of students for the request
        } catch { // if an error occurs return o
            return 0
        }
    }
    
}

extension Course { //declaring the course extension
    static func dbaData(context: NSManagedObjectContext) -> Int { // static way to count the no of course object in core data
        let request = NSFetchRequest<Course>(entityName: "Course") // make the fetch request for the course entity
        request.entity = Course.entity() // setting the entity for the request
        do {
            return try context.count(for: request) // try to count the no of course records in the context
        } catch {
            return 0 // if this shows error then 0
        }
    }
}
