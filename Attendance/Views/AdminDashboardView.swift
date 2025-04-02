// MARK: - AdminDashboardView.swift
import SwiftUI
import CoreData

struct AdminDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            // Student Management
            NavigationView {
                StudentManagementView()
            }
            .tabItem {
                Label("Students", systemImage: "person.3.fill")
            }
            
            // Course Management
            NavigationView {
                CourseManagementView()
            }
            .tabItem {
                Label("Courses", systemImage: "book.fill")
            }
            
            // Admin Profile
            NavigationView {
                AdminProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .accentColor(.purple)
        .navigationBarTitle("Admin Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: Button("Logout") {
            authVM.logout()
        })
    }
}

struct AdminProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.purple)
                .padding(.top, 40)
            
            Text("Administrator")
                .font(.title)
                .fontWeight(.bold)
            
            Text("admin12@gmail.com")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .navigationTitle("Admin Profile")
    }
}
