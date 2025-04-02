import SwiftUI
import CoreData

struct AddEditStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var student: Student?
    
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
                    Button(student == nil ? "Add Student" : "Save Changes") {
                        saveStudent()
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
                }
            }
            .navigationTitle(student == nil ? "New Student" : "Edit Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                if let student = student {
                    name = student.name ?? ""
                    email = student.email ?? ""
                    password = student.password ?? ""
                }
            }
        }
    }
    
    private func saveStudent() {
        let studentToSave = student ?? Student(context: viewContext)
        studentToSave.id = UUID()
        studentToSave.name = name
        studentToSave.email = email
        studentToSave.password = password
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "Failed to save student: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
