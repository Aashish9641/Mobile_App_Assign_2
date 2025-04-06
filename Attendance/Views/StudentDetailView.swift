
// MARK: - StudentDetailView.swift
import SwiftUI
import CoreData

struct StudentDetailView: View {
    @ObservedObject var student: Student
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Form {
            Section(header: Text("Student Information")) {
                ifRo(icon: "person.fill", label: "Name", value: student.name ?? "Unknown")
                ifRo(icon: "envelope.fill", label: "Email", value: student.email ?? "No email")
            }

            Section(header: Text("Enrollment Details")) {
                NavigationLink(destination: CourseEnrollmentView(student: student)) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.purple)
                        Text("Manage Course Enrollment")
                    }
                }

                if !(student.courses?.isEmpty ?? true) {
                    ForEach(Array(student.courses as? Set<Course> ?? []), id: \.self) { course in
                        HStack {
                            Image(systemName: "text.book.closed")
                                .foregroundColor(.blue)
                            Text(course.name ?? "Unknown Course")
                            Spacer()
                            Text(course.code ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Student Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    do {
                        try viewContext.save() // Use injected context
                    } catch {
                        print("❌ Save error: \(error.localizedDescription)")
                    }
                } label: {
                    Text("Save Changes")
                }
            }
        }
    }
}

struct ifRo: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.purple)
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
