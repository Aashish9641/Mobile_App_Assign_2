import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showAdminLogin = false
    @State private var showStudentLogin = false
    @State private var animateElements = false
    
    // Premium color palette
    let primaryBlue = Color(red: 0.07, green: 0.15, blue: 0.31)
    let secondaryBlue = Color(red: 0.14, green: 0.35, blue: 0.68)
    let adminPurple = Color(red: 0.58, green: 0.45, blue: 0.94)
    let studentGreen = Color(red: 0.30, green: 0.75, blue: 0.60)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Clean gradient background without image
                LinearGradient(
                    gradient: Gradient(colors: [primaryBlue, secondaryBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // University header with subtle animation
                    VStack(spacing: 12) {
                        if #available(iOS 15.0, *) {
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 60, weight: .thin))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.white)
                                .scaleEffect(animateElements ? 1 : 0.9)
                                .opacity(animateElements ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateElements)
                        } else {
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 60, weight: .thin))
                                .foregroundColor(.white)
                                .scaleEffect(animateElements ? 1 : 0.9)
                                .opacity(animateElements ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateElements)
                        }
                        
                        Text(" University of GraceTech")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(0.5)
                            .opacity(animateElements ? 1 : 0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: animateElements)
                        
                        Text("Attendance & Social System")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .opacity(animateElements ? 1 : 0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Role selection cards with refined design
                    VStack(spacing: 20) {
                        RoleCard(
                            icon: "key.fill",
                            title: "Administrator",
                            subtitle: "Students & course Access",
                            color: adminPurple,
                            action: { showAdminLogin = true }
                        )
                        .opacity(animateElements ? 1 : 0)
                        .offset(x: animateElements ? 0 : -30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: animateElements)
                        
                        RoleCard(
                            icon: "graduationcap.fill",
                            title: "Student",
                            subtitle: "Campus Access",
                            color: studentGreen,
                            action: { showStudentLogin = true }
                        )
                        .opacity(animateElements ? 1 : 0)
                        .offset(x: animateElements ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: animateElements)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Elegant footer
                    Text("Version 5.0")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 24)
                        .opacity(animateElements ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.8), value: animateElements)
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
            .fullScreenCover(isPresented: $authVM.authoriZed) {
                if authVM.panelAdmi {
                    AdminDashboardView()
                        .environmentObject(authVM)
                } else {
                    StudentDashboardView()
                        .environmentObject(authVM)
                }
            }
            .onAppear {
                animateElements = true
            }
        }
        .accentColor(.white)
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1)
            .animation(.interactiveSpring(), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
