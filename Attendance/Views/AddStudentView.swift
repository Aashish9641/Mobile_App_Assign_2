// MARK: - AddStudentView.swift
import SwiftUI
import CoreData

struct AddStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button("Save Student") {
                        saveStudent()
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
                }
            }
            .navigationTitle("New Student")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveStudent()
                }
                .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveStudent() {
        let newStudent = Student(context: viewContext)
        newStudent.id = UUID()
        newStudent.name = name
        newStudent.email = email
        newStudent.password = AuthViewModel().hashPassword(password)
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "Failed to save student: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
