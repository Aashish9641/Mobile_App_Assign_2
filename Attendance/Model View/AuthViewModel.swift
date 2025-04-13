import Foundation // imporing teh foundation for basic operations
import CoreData // importing coredata for management of database

// making view model for authentication handling
class AuthViewModel: ObservableObject {
    @Published var authoriZed = false // tracking if the useer is logged in or not
    @Published var panelAdmi = false // verify if the admin is there or not
    @Published var studeRight: Student? // operation for holdiong the current user
    @Published var throwEr: String? // operation to show the error message
    
    private let context = PersistenceController.shared.container.viewContext // context for using core data management
    
    // make function to operate the login mechanism
    func logging(email: String, password: String) {
        // Admin panle side login
        if email.lowercased() == "admin12@gmail.com" && password == "admin123" { // declaring the username and password for admin predefined
            authoriZed = true // set predefined or authorized username
            panelAdmi = true // setting the access of admin panel
            throwEr = nil // clearing the extra message
            return // return for go back
        }
        
        // Student login panel side
        let req = NSFetchRequest<Student>(entityName: "Student") // making the fetch request in student panel area
        req.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password) // using NSpredicate to write the email and password from database table
        
        do {
            let students = try context.fetch(req) // setting the fetch the matching students from core data
            if let student = students.first { // if this is match then go to login for students
                studeRight = student // storing the login student user
                authoriZed = true // making it authorized part
                panelAdmi = false // declaring this is not an admin
                throwEr = nil // clearing the error
            } else {
                throwEr = "Invalid Credentials" // if given inputs are not matched then show this error
            }
        } catch {
            throwEr = "Login failed. Please try again later." // show the erro message if there any issue while fetching
        }
    }
    
    func goBack() { // function to operate the logout fetaure
        authoriZed = false // authorization revoking
        panelAdmi = false // Resetting the access of admin
        studeRight = nil // making clear the data
    }
}
