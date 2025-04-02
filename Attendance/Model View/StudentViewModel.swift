import SwiftUI
import CoreData

class StudentViewModel: ObservableObject {
    private let context = PersistenceController.shared.container.viewContext
    
    func updateStudent(student: Student, newName: String, newPassword: String) {
        student.name = newName
        student.password = newPassword // Removed hashPassword for simplicity
        PersistenceController.shared.save()
    }
    
    func enrollInCourse(student: Student, course: Course) {
        student.mutableSetValue(forKey: "courses").add(course)
        PersistenceController.shared.save()
    }
}
