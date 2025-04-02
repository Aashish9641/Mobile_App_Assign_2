import Foundation
import CoreData

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var currentStudent: Student?
    @Published var errorMessage: String?
    
    private let context = PersistenceController.shared.container.viewContext
    
    func login(email: String, password: String) {
        // Admin login
        if email.lowercased() == "admin12@gmail.com" && password == "admin123" {
            isAuthenticated = true
            isAdmin = true
            errorMessage = nil
            return
        }
        
        // Student login
        let request = NSFetchRequest<Student>(entityName: "Student")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let students = try context.fetch(request)
            if let student = students.first {
                currentStudent = student
                isAuthenticated = true
                isAdmin = false
                errorMessage = nil
            } else {
                errorMessage = "Invalid credentials"
            }
        } catch {
            errorMessage = "Login failed. Please try again."
        }
    }
    
    func logout() {
        isAuthenticated = false
        isAdmin = false
        currentStudent = nil
    }
}
