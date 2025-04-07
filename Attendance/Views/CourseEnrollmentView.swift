import SwiftUI
import CoreData

struct CourseEnrollmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var student: Student
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var allCourses: FetchedResults<Course>

    var body: some View {
        NavigationView {
            List {
                ForEach(allCourses) { course in
                    raps(
                        course: course,
                        isEnrolled: student.coursesArray.contains(course),
                        toggleAction: { toggleEnrollment(for: course) }
                    )
                }
            }
            .navigationTitle("Enroll in Courses")
        }
    }
    
    private func toggleEnrollment(for course: Course) {
        if student.coursesArray.contains(course) {
            student.safeRemoveCourse(course, context: viewContext)
        } else {
            student.safeAddCourse(course, context: viewContext)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

struct raps: View {
    let course: Course
    let isEnrolled: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        HStack {
            Text(course.name ?? "Unknown Course")
            Spacer()
            if isEnrolled {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: toggleAction)
    }
}
