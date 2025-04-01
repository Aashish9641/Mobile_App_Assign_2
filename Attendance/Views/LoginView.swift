// MARK: - LoginView.swift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    let isAdmin: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Role-specific header
                VStack {
                    Image(systemName: isAdmin ? "key.fill" : "graduationcap.fill")
                        .font(.system(size: 50))
                        .foregroundColor(isAdmin ? .purple : .green)
                    
                    Text(isAdmin ? "Admin Portal" : "Student Portal")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 50)
                
                // Login form
                VStack(spacing: 20) {
                    TextField("University Email", text: $email)
                        .textFieldStyle(UniversityTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(UniversityTextFieldStyle())
                    
                    Button(action: login) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isAdmin ? Color.purple : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 30)
                
                if !isAdmin {
                    Text("Contact admin if you forgot your credentials")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func login() {
        if isAdmin {
            // Predefined admin credentials
            if email == "admin12@gmail.com" && password == "admin123" {
                authVM.login(email: email, password: password)
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = "Invalid admin credentials"
                showAlert = true
            }
        } else {
            // Student login (credentials managed by admin)
            authVM.login(email: email, password: password)
            if authVM.isAuthenticated {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = "Invalid student credentials"
                showAlert = true
            }
        }
    }
}

struct UniversityTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}
