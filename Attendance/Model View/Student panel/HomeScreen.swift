//
//  HomeScreen.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class HomeScreen: UIViewController {
        @Environment(\.managedObjectContext) private var viewContext
        
        var body: some View {
            TabView {
                // Attendance
                NavigationView {
                    AttendanceScreen()
                }
                .tabItem {
                    Label("Attendance", systemImage: "checkmark.circle")
                }
                
                // Courses
                NavigationView {
                    CourseListStudentView()
                }
                .tabItem {
                    Label("My Courses", systemImage: "book")
                }
                
                // Social
                NavigationView {
                    SocialFeedView()
                }
                .tabItem {
                    Label("Social", systemImage: "message")
                }
                
                // Profile
                NavigationView {
                    ProfileScreen()
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
        }
    }

}
