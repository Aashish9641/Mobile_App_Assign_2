import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    let isAdmin: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showPassword = false
    @State private var isLoading = false
    
    // Custom color scheme
    private var accentColor: Color {
        isAdmin ? Color(red: 0.58, green: 0.45, blue: 0.94) : Color(red: 0.30, green: 0.75, blue: 0.60)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.07, green: 0.15, blue: 0.31),
                isAdmin ? Color(red: 0.14, green: 0.35, blue: 0.68) : Color(red: 0.20, green: 0.60, blue: 0.50)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 32) {
                    // Header Section
                    VStack(spacing: 20) {
                        if #available(iOS 15.0, *) {
                            Image(systemName: isAdmin ? "key.fill" : "graduationcap.fill")
                                .font(.system(size: 60, weight: .thin))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(accentColor)
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        VStack(spacing: 8) {
                            Text(isAdmin ? "Admin Portal" : "Student Portal")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("GraceTech University")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 40)
                    
                    // Form Section
                    VStack(spacing: 24) {
                        // Email Field
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white.opacity(0.7))
                            TextField("University Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.white)
                        }
                        .textFieldStyle(UniversityTextFieldStyle(accentColor: accentColor))
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white.opacity(0.7))
                            
                            if showPassword {
                                TextField("Password", text: $password)
                                    .foregroundColor(.white)
                            } else {
                                SecureField("Password", text: $password)
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .textFieldStyle(UniversityTextFieldStyle(accentColor: accentColor))
                        
                        // Login Button
                        Button(action: login) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(LoginButtonStyle(accentColor: accentColor, isLoading: isLoading))
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 32)
                    
                    if !isAdmin {
                        Text("Contact admin for credential recovery")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: dismiss) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Back")
                    }
                    .foregroundColor(accentColor)
                },
                trailing: Button("Close") { dismiss() }
                    .foregroundColor(accentColor)
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Failed").foregroundColor(accentColor),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func login() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            defer { isLoading = false }
            
            if isAdmin {
                if email == "admin12@gmail.com" && password == "admin123" {
                    authVM.login(email: email, password: password)
                    dismiss()
                } else {
                    alertMessage = "Invalid admin credentials"
                    showAlert = true
                }
            } else {
                authVM.login(email: email, password: password)
                if authVM.isAuthenticated {
                    dismiss()
                } else {
                    alertMessage = "Invalid student credentials"
                    showAlert = true
                }
            }
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Custom Styles
struct UniversityTextFieldStyle: TextFieldStyle {
    var accentColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(accentColor.opacity(0.5), lineWidth: 1)
            )
    }
}

struct LoginButtonStyle: ButtonStyle {
    var accentColor: Color
    var isLoading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(accentColor)
                    .shadow(color: accentColor.opacity(0.3), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(isLoading ? 0.8 : 1)
    }
}
