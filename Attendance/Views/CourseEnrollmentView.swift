import SwiftUI
import CoreData

struct CourseEnrollmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var student: Student
    
    // Add fetch request directly in the view
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var allCourses: FetchedResults<Course>
    
    // Public initializer
    init(student: Student) {
        self.student = student
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(allCourses) { course in
                    HStack {
                        Text(course.name ?? "Unknown Course")
                        Spacer()
                        if isEnrolled(in: course) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleEnrollment(for: course)
                    }
                }
            }
            .navigationTitle("Enroll in Courses")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func isEnrolled(in course: Course) -> Bool {
        student.courses?.contains(course) ?? false
    }
    
    private func toggleEnrollment(for course: Course) {
        withAnimation {
            if isEnrolled(in: course) {
                student.mutableSetValue(forKey: "courses").remove(course)
            } else {
                student.mutableSetValue(forKey: "courses").add(course)
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to update enrollment: \(error.localizedDescription)")
            }
        }
    }
}
