//
//  ProfileScreen.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class ProfileScreen: UIViewController {
        @Environment(\.managedObjectContext) private var viewContext
        @State private var currentPassword = ""
        @State private var newPassword = ""
        @State private var confirmPassword = ""
        @State private var showAlert = false
        @State private var alertMessage = ""
        
        var body: some View {
            Form {
                Section(header: Text("Change Password")) {
                    SecureField("Current Password", text: $currentPassword)
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                    
                    Button("Update Password") {
                        updatePassword()
                    }
                    .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
                }
            }
            .navigationTitle("My Profile")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Profile"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
        private func updatePassword() {
            guard newPassword == confirmPassword else {
                alertMessage = "Passwords don't match"
                showAlert = true
                return
            }
            
            guard let student = getCurrentStudent(),
                  student.password == currentPassword else {
                alertMessage = "Current password is incorrect"
                showAlert = true
                return
            }
            
            student.password = newPassword
            
            do {
                try viewContext.save()
                alertMessage = "Password updated successfully"
                showAlert = true
            } catch {
                alertMessage = "Error updating password: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

}
