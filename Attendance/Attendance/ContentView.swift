// MARK: - ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showAdminLogin = false
    @State private var showStudentLogin = false
    
    // University color scheme
    let universityColors = [Color(red: 0.1, green: 0.3, blue: 0.7), Color(red: 0.2, green: 0.5, blue: 0.9)]
    
    var body: some View {
        NavigationView {
            ZStack {
                // University-themed gradient background
                LinearGradient(
                    gradient: Gradient(colors: universityColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // University header
                    VStack {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        Text("GraceTech University")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Role selection buttons
                    VStack(spacing: 25) {
                        // Admin Button
                        RoleButton(
                            icon: "key.fill",
                            title: "Administrator",
                            color: .purple,
                            action: { showAdminLogin = true }
                        )
                        
                        // Student Button
                        RoleButton(
                            icon: "graduationcap.fill",
                            title: "Student",
                            color: .green,
                            action: { showStudentLogin = true }
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAdminLogin) {
                LoginView(isAdmin: true)
                    .environmentObject(authVM)
            }
            .sheet(isPresented: $showStudentLogin) {
                LoginView(isAdmin: false)
                    .environmentObject(authVM)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RoleButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
