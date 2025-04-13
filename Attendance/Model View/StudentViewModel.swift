import SwiftUI // imporing the swift UI for better UIUX
import CoreData // management of the database and importing the coredata

// view model operation for student management
class StudentViewModel: ObservableObject {
    // Access of the coredata for  data handling
    private let context = PersistenceController.shared.container.viewContext
    
    // make function to update the studnets name and password attributes
    func studeModi(student: Student, newName: String, newPassword: String) {
        student.name = newName // modify the name of student
        student.password = newPassword // modify the password
        PersistenceController.shared.save() // saving teh changes to core database
    }
    // Function to enroll the course to students
    func rollCours(student: Student, course: Course) {
        // add the course to the relationship of students and courses
        student.mutableSetValue(forKey: "courses").add(course)
        PersistenceController.shared.save() // saved the modified realtion in core database using presistence
    }
}

