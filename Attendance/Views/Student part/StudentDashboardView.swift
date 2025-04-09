import SwiftUI

// MARK: - StudentDashboardView.swift
struct StudentDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        TabView {
            // Home
            NavigationView {
                StudentHomeView()
                    .navigationBarItems(trailing: logoutButton)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // Attendance
            NavigationView {
                AttendanceView()
                    .navigationBarItems(trailing: logoutButton)
            }
            .tabItem {
                Label("Attendance", systemImage: "checkmark.circle.fill")
            }
            
            // Timeline
            NavigationView {
                if #available(iOS 15.0, *) {
                    TimelineView()
                        .navigationBarItems(trailing: logoutButton)
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem {
                Label("Timeline", systemImage: "message.fill")
            }
            
            // Profile
            NavigationView {
                if #available(iOS 15.0, *) {
                    StudentProfileView()
                        .navigationBarItems(trailing: logoutButton)
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .accentColor(.green)
    }
    
    private var logoutButton: some View {
        Button(action: {
            authVM.logout()
        }) {
            Text("Logout")
                .foregroundColor(.red)
        }
    }
}

struct StudentHomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Welcome Header
                VStack(spacing: 10) {
                    Text("Welcome back,")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text(authVM.currentStudent?.name ?? "Student")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                // Quick Actions
                HStack(spacing: 15) {
                    NavigationLink(destination: AttendanceView()) {
                        QuickActionButton(icon: "checkmark.circle.fill", label: "Mark Attendance", color: .blue)
                    }
                    
                    if #available(iOS 15.0, *) {
                        NavigationLink(destination: TimelineView()) {
                            QuickActionButton(icon: "message.fill", label: "Post Update", color: .green)
                        }
                    } else {
                        // Fallback on earlier versions
                    };if #available(iOS 15.0, *) {
                        NavigationLink(destination: TimelineView()) {
                            QuickActionButton(icon: "message.fill", label: "Post Update", color: .green)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .padding(.horizontal)
                
                // Today's Courses
                VStack(alignment: .leading) {
                    Text("Your Courses")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if courses.isEmpty {
                        Text("No courses enrolled")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(courses) { course in
                            CourseCard(course: course)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Home")
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .padding()
                .background(color.opacity(0.2))
                .foregroundColor(color)
                .clipShape(Circle())
            
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct CourseCard: View {
    let course: Course
    
    var body: some View {
        HStack {
            Image(systemName: "book.closed.fill")
                .font(.title)
                .foregroundColor(.purple)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.name ?? "Unknown Course")
                    .font(.headline)
                
                Text(course.schedule ?? "No schedule")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
