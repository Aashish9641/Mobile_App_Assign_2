import SwiftUI
import CoreData

@available(iOS 15, *)
struct AddEditStudentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    
    var student: Student?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("Full Name", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .padding(.bottom, 10)
                    
                    TextField("University Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .padding(.bottom, 10)
                    
                    SecureField("Temporary Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .padding(.bottom, 10)
                }
                
                Section {
                    Button(student == nil ? "Add Student" : "Save Changes") {
                        saveStudent()
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                    .foregroundColor(.white)
                    .padding(.top)
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
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Student \(student == nil ? "added" : "updated") successfully"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
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
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else {
            alertMessage = "All fields are required"
            showingAlert = true
            return
        }
        
        guard isValidEmail(email) else {
            alertMessage = "Please enter a valid university email"
            showingAlert = true
            return
        }
        
        let studentToSave = student ?? Student(context: viewContext)
        studentToSave.id = UUID()
        studentToSave.name = name
        studentToSave.email = email
        studentToSave.password = password
        
        do {
            try viewContext.save()
            showSuccessAlert = true
        } catch {
            alertMessage = "Operation failed: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
