//
//  AttendanceScreen.swift
//  Attendance
//
//  Created by NAAMI COLLEGE on 31/03/2025.
//

import UIKit

class AttendanceScreen: UIViewController {

        @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(
            entity: Course.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)]
        ) var courses: FetchedResults<Course>
        
        @State private var selectedCourse: Course?
        @State private var showAlert = false
        @State private var alertMessage = ""
        
        var body: some View {
            Group {
                if selectedCourse == nil {
                    List(courses, id: \.self) { course in
                        Button(course.name ?? "Unknown") {
                            selectedCourse = course
                        }
                    }
                } else {
                    VStack {
                        Text("Marking attendance for \(selectedCourse?.name ?? "")")
                        Button("Mark Present") {
                            markAttendance()
                        }
                        .padding()
                        
                        Button("Back") {
                            selectedCourse = nil
                        }
                    }
                }
            }
            .navigationTitle("Attendance")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Attendance"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
        private func markAttendance() {
            guard let course = selectedCourse else { return }
            
            // Get current student (you'll need to implement this)
            if let student = getCurrentStudent() {
                let attendance = Attendance(context: viewContext)
                attendance.id = UUID()
                attendance.date = Date()
                attendance.status = true
                attendance.student = student
                attendance.course = course
                
                do {
                    try viewContext.save()
                    alertMessage = "Attendance marked successfully!"
                    showAlert = true
                } catch {
                    alertMessage = "Error marking attendance: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
        
        private func getCurrentStudent() -> Student? {
            // Implement logic to get logged in student
            return nil
        }
    }

}
