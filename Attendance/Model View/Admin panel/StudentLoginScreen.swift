//
//  StudentLoginScreen.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class StudentLoginScreen: UIViewController {
        @Environment(\.managedObjectContext) private var viewContext
        @Binding var isStudentLoggedIn: Bool
        @State private var email = ""
        @State private var password = ""
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
                .navigationTitle("Student Login")
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        
        private func login() {
            let request: NSFetchRequest<Student> = Student.fetchRequest()
            request.predicate = NSPredicate(format: "email == %@ AND password == %@ AND isAdmin == false", email, password)
            
            do {
                let students = try viewContext.fetch(request)
                if let student = students.first {
                    student.lastLogin = Date()
                    try viewContext.save()
                    isStudentLoggedIn = true
                } else {
                    alertMessage = "Invalid student credentials"
                    showAlert = true
                }
            } catch {
                alertMessage = "Login error: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

}
