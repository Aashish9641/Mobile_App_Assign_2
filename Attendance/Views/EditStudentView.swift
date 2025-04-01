// MARK: - EditStudentView.swift
import SwiftUI
import CoreData

struct EditStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var student: Student
    
    @State private var name: String
    @State private var email: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(student: Student) {
        self.student = student
        _name = State(initialValue: student.name ?? "")
        _email = State(initialValue: student.email ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Update Student") {
                        updateStudent()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
            .navigationTitle("Edit Student")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    updateStudent()
                }
                .disabled(name.isEmpty || email.isEmpty)
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func updateStudent() {
        student.name = name
        student.email = email
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "Failed to update student: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
