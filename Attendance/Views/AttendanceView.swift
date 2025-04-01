// MARK: - 📂 Views/AttendanceView.swift
import SwiftUI
import CoreData

struct AttendanceView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)]
    ) var courses: FetchedResults<Course>
    
    var body: some View {
        List {
            ForEach(courses) { course in
                HStack {
                    Text(course.name ?? "Unknown Course")
                    Spacer()
                    Button(action: {
                        markAttendance(for: course)
                    }) {
                        Text("Mark Attendance")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .navigationTitle("Course Attendance")
    }
    
    private func markAttendance(for course: Course) {
        let attendance = Attendance(context: PersistenceController.shared.container.viewContext)
        attendance.id = UUID()
        attendance.date = Date()
        attendance.student = authVM.currentStudent
        attendance.course = course
        PersistenceController.shared.save()
    }
}
