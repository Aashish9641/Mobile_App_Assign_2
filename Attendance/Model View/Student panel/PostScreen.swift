//
//  PostScreen.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class PostScreen: UIViewController {
        @Environment(\.managedObjectContext) private var viewContext
        @Environment(\.presentationMode) var presentationMode
        
        @State private var content = ""
        @State private var isGlobal = false
        @State private var selectedCourse: Course?
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Post Content")) {
                        TextEditor(text: $content)
                            .frame(minHeight: 100)
                    }
                    
                    Section {
                        Toggle("Global Post", isOn: $isGlobal)
                        
                        if !isGlobal {
                            Picker("Course", selection: $selectedCourse) {
                                ForEach(getStudentCourses(), id: \.self) { course in
                                    Text(course.name ?? "Unknown").tag(course as Course?)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button("Post") {
                            createPost()
                        }
                        .disabled(content.isEmpty || (!isGlobal && selectedCourse == nil))
                    }
                }
                .navigationTitle("New Post")
                .navigationBarItems(trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
        private func getStudentCourses() -> [Course] {
            // Implement logic to get courses for current student
            return []
        }
        
        private func createPost() {
            guard let student = getCurrentStudent() else { return }
            
            let post = Post(context: viewContext)
            post.id = UUID()
            post.content = content
            post.timestamp = Date()
            post.isGlobal = isGlobal
            post.author = student
            
            if !isGlobal {
                post.course = selectedCourse
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error saving post: \(error)")
            }
        }
    }

}
