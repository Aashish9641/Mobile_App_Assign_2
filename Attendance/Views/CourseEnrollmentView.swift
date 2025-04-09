import SwiftUI
import CoreData

struct CourseEnrollmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var student: Student
    @State private var message: String? = nil
    @State private var refreshID = UUID()  // For forcing view updates
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var allCourses: FetchedResults<Course>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(allCourses) { course in
                        CourseRow(
                            course: course,
                            isEnrolled: student.coursesArray.contains(course),
                            toggleAction: { toggleEnrollment(for: course) }
                        )
                    }
                }
                .navigationTitle("Enroll in Courses")
                
                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(message.contains("assigned") ? .green : .red)
                        .padding()
                        .transition(.opacity)
                        .animation(.easeInOut, value: message)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    self.message = nil
                                }
                            }
                        }
                }
            }
            .id(refreshID)  // Force view refresh when ID changes
        }
    }
    
    private func toggleEnrollment(for course: Course) {
        viewContext.perform {
            let wasEnrolled = student.coursesArray.contains(course)
            
            if wasEnrolled {
                student.safeRemoveCourse(course, context: viewContext)
                message = "Course \(course.name ?? "Unknown") unassigned"
            } else {
                student.safeAddCourse(course, context: viewContext)
                message = "Course \(course.name ?? "Unknown") assigned!"
            }
            
            do {
                try viewContext.save()
                // Force view update
                refreshID = UUID()
                // Notify parent view of changes
                student.objectWillChange.send()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
                message = "Failed to update enrollment"
            }
        }
    }
}

struct CourseRow: View {
    let course: Course
    let isEnrolled: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(course.name ?? "Unknown Course")
                    .font(.headline)
                Text(course.code ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: toggleAction) {
                Text(isEnrolled ? "Unassign" : "Assign")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isEnrolled ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
