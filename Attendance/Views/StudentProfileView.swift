import SwiftUI
import CoreData

@available(iOS 15.0, *)
struct StudentProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isEditing = false
    @State private var editedName = ""
    
    var student: Student? {
        authVM.currentStudent
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    if isEditing {
                        TextField("Name", text: $editedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .font(.title)
                    } else {
                        Text(student?.name ?? "Student Name")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Text(student?.email ?? "student@university.edu")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)
                
                // Edit Button
                Button {
                    if isEditing {
                        saveProfileChanges()
                    } else {
                        editedName = student?.name ?? ""
                        isEditing = true
                    }
                } label: {
                    Label(isEditing ? "Save Changes" : "Edit Profile", systemImage: isEditing ? "checkmark" : "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Password Update Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Change Password")
                        .font(.headline)
                    
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    
                    Button(action: updatePassword) {
                        Label("Update Password", systemImage: "key.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("My Profile")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Profile Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveProfileChanges() {
        guard let student = student else { return }
        
        student.name = editedName
        isEditing = false
        
        do {
            try viewContext.save()
            alertMessage = "Profile updated successfully"
            showAlert = true
        } catch {
            alertMessage = "Failed to update profile: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    private func updatePassword() {
        guard !newPassword.isEmpty else { return }
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        
        guard let student = student else { return }
        
        student.password = newPassword // Simple storage for demo
        newPassword = ""
        confirmPassword = ""
        
        do {
            try viewContext.save()
            alertMessage = "Password updated successfully"
            showAlert = true
        } catch {
            alertMessage = "Failed to update password: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
