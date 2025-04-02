import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showAdminLogin = false
    @State private var showStudentLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // University-themed background
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.3, blue: 0.7), Color(red: 0.2, green: 0.5, blue: 0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // University header with logo
                    VStack(spacing: 10) {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("GraceTech University")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Attendance & Social System")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Role selection cards
                    VStack(spacing: 20) {
                        RoleCard(
                            icon: "key.fill",
                            title: "Administrator",
                            color: .purple,
                            action: { showAdminLogin = true }
                        )
                        
                        RoleCard(
                            icon: "graduationcap.fill",
                            title: "Student",
                            color: .green,
                            action: { showStudentLogin = true }
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Footer
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 20)
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
            .fullScreenCover(isPresented: $authVM.isAuthenticated) {
                if authVM.isAdmin {
                    AdminDashboardView()
                        .environmentObject(authVM)
                } else {
                    StudentDashboardView()
                        .environmentObject(authVM)
                }
            }
        }
    }
}

struct RoleCard: View {
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
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
