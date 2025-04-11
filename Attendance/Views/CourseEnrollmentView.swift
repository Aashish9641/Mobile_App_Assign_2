import SwiftUI
import CoreData

struct CourseEnrollmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var student: Student
    @State private var message: String? = nil

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var allCourses: FetchedResults<Course>
    
    // This state will track the enrollment status of courses locally
    @State private var enrollmentStatus: [UUID: Bool] = [:]  // Store status by course ID

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(allCourses) { course in
                        CourseRow(
                            course: course,
                            isEnrolled: enrollmentStatus[course.id ?? UUID()] ?? student.arrCou.contains(course),
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
        }
        .onAppear {
            // Initialize enrollment status only once when the view first appears
            if enrollmentStatus.isEmpty {
                initializeEnrollmentStatus()
            }
        }
    }
    
    private func toggleEnrollment(for course: Course) {
        // Get the current enrollment status from the local state
        let wasEnrolled = enrollmentStatus[course.id ?? UUID()] ?? student.arrCou.contains(course)
        
        // Toggle the enrollment status
        if wasEnrolled {
            student.delCour(course, context: viewContext)
            message = "Course \(course.name ?? "Unknown") unassigned"
            enrollmentStatus[course.id ?? UUID()] = false  // Update status to "unassigned"
        } else {
            student.addSafe(course, context: viewContext)
            message = "Course \(course.name ?? "Unknown") assigned!"
            enrollmentStatus[course.id ?? UUID()] = true  // Update status to "assigned"
        }
        
        do {
            try viewContext.save()
            // Notify parent view of changes
            student.objectWillChange.send()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
            message = "Failed to update enrollment"
        }
    }
    
    // This function initializes the enrollment status when the view first appears
    private func initializeEnrollmentStatus() {
        // Ensure enrollmentStatus reflects the actual status in the database
        for course in allCourses {
            // Check if the course is currently assigned to the student in Core Data
            let isEnrolled = student.arrCou.contains(course)
            enrollmentStatus[course.id ?? UUID()] = isEnrolled
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
                Text(isEnrolled ? "Assigned" : "Unassigned")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isEnrolled ? Color.green : Color.red)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
