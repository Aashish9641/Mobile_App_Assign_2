import Foundation // importing the foundation to provide the basic like string
import CoreData // importing the coredata to management

@objc(Student) // defining the students and core management and make it visible
public class Student: NSManagedObject, Identifiable { // NS manage object
    @NSManaged public var id: UUID? // providing the unique id for student
    @NSManaged public var name: String? // adding the student name
    @NSManaged public var email: String? // declaring the emnail of student
    @NSManaged public var password: String? // declaring the password for student
    @NSManaged public var courses: NSSet? // setting the course to student and work as foriegn key
    
    // it returns alphabetical sorted arry of course
    public var arrCou: [Course] {
        let set = courses as? Set<Course> ?? [] // safely cast NSset to set course
        return set.sorted { $0.name ?? "" < $1.name ?? "" } //sorted by name  of the course
    }
    
    // adding teh course to using teh safe process
    public func addSafe(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait { // make sure the threat safe core data operation
            print("Attempting to add course: \(course.name ?? "Unknown") to student: \(name ?? "Unknown")") // message to adding the course as well
            // verify if the course is linked or not
            if let fixCour = courses as? NSMutableSet, !fixCour.contains(course) { // add the course to students
                fixCour.add(course) // adding the course to students
                course.plustStu(self) // modify the course student set
                print("Course Added Successfully: \(course.name ?? "Unknown") to student: \(name ?? "Unknown")") // show the message of succesful
                do {
                    try context.save() // management of try and catch method
                } catch {
                    print("Failed to save the course : \(error.localizedDescription)") // if the save is failed the show this message
                }
            } else {
                print("Course is already exists here.") // show this mesage if it is already exists.
            }
        }
    }
    
    // function to rem,ove teh course using safe method
    public func delCour(_ course: Course, context: NSManagedObjectContext) {
        context.performAndWait { // core data operation
            print("try to to delete the  course: \(course.name ?? "Unknown") from student: \(name ?? "Unknown")") //show the course message if try to attempt
            // verify if the course os exist in the list of students
            if let fixCour = courses as? NSMutableSet, fixCour.contains(course) { // delete the students
                fixCour.remove(course) // update the course
                course.deltoStu(self)
                print("Successfully removed course: \(course.name ?? "Unknown") from student: \(name ?? "Unknown")")
                do {
                    try context.save() // saving the change
                } catch {
                    print("Failed to save context: \(error.localizedDescription)") // messageif the saving is failed
                }
            } else {
                print("Course is not  found in this student's courses.") // if the couse is not found then show the error
            }
        }
    }
    
    // core data fetch data request and class method for the studnet entity
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student") // added the student entity
    }
}
