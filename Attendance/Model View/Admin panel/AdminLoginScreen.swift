import SwiftUI
import UIKit
struct AdminLoginScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isAdminLoggedIn: Bool
    @State private var email = "admin@grace.edu"
    @State private var password = "admin123"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                
                Button("Login") {
                    login()
                }
                .disabled(email.isEmpty || password.isEmpty)
            }
            .navigationTitle("Admin Login")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func login() {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@ AND isAdmin == true", email, password)
        
        do {
            let admins = try viewContext.fetch(request)
            if admins.count == 1 {
                isAdminLoggedIn = true
            } else {
                alertMessage = "Invalid admin credentials"
                showAlert = true
            }
        } catch {
            alertMessage = "Login error: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
