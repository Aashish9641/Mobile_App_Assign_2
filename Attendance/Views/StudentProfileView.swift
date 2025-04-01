// MARK: - StudentProfileView.swift
import SwiftUI

struct StudentProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingTimeline = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    Text(authVM.currentStudent?.name ?? "Student Name")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(authVM.currentStudent?.email ?? "student@university.edu")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Password Update Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Settings")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    
                    Button(action: updatePassword) {
                        Text("Update Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(newPassword.isEmpty || confirmPassword.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Timeline Access
                Button(action: {
                    showingTimeline = true
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Go to Timeline")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingTimeline) {
                    TimelineView()
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("My Profile")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func updatePassword() {
        guard !newPassword.isEmpty else { return }
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords don't match"
            showingAlert = true
            return
        }
        
        // In a real app, you would hash and save this securely
        authVM.currentStudent?.password = newPassword
        alertMessage = "Password updated successfully"
        showingAlert = true
        newPassword = ""
        confirmPassword = ""
    }
}
