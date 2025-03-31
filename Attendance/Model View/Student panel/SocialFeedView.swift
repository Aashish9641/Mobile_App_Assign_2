//
//  SocialFeedView.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class SocialFeedView: UIViewController {
        @Environment(\.managedObjectContext) private var viewContext
        @State private var selectedScope = 0 // 0 = Global, 1 = Course
        
        var body: some View {
            VStack {
                Picker("Scope", selection: $selectedScope) {
                    Text("Global").tag(0)
                    Text("Course").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    if selectedScope == 0 {
                        GlobalPostsView()
                    } else {
                        CoursePostsView()
                    }
                }
            }
            .navigationTitle("Social Feed")
            .navigationBarItems(trailing: NavigationLink(destination: PostScreen()) {
                Image(systemName: "plus")
            })
        }
    }

}
