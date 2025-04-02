import SwiftUI
import CoreData

struct AttendanceView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    @State private var selectedDate = Date()
    @State private var showingConfirmation = false
    @State private var confirmationCourse: Course?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                if courses.isEmpty {
                    VStack {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No courses enrolled")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Contact admin to enroll in courses")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(courses) { course in
                        AttendanceCard(
                            course: course,
                            selectedDate: selectedDate,
                            onMarkAttendance: {
                                confirmationCourse = course
                                showingConfirmation = true
                            }
                        )
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Mark Attendance")
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Attendance"),
                message: Text("Confirm you're marking attendance for \(confirmationCourse?.name ?? "this course")"),
                primaryButton: .default(Text("Mark Present")) {
                    if let course = confirmationCourse {
                        markAttendance(for: course)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func markAttendance(for course: Course) {
        let attendance = Attendance(context: viewContext)
        attendance.id = UUID()
        attendance.date = selectedDate
        attendance.status = "Present"
        attendance.student = authVM.currentStudent
        attendance.course = course
        
        PersistenceController.shared.save()
    }
}

struct AttendanceCard: View {
    let course: Course
    let selectedDate: Date
    let onMarkAttendance: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "book.closed.fill")
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.name ?? "Unknown Course")
                        .font(.headline)
                    
                    Text(course.schedule ?? "No schedule")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text(formattedDate(date: selectedDate))
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: onMarkAttendance) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Mark Present")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
