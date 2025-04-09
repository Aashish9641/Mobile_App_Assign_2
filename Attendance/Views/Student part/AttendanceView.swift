import SwiftUI
import CoreData

struct AttendanceView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.date, ascending: false)],
        animation: .default)
    private var attendances: FetchedResults<Attendance>

    @State private var selectedDate = Date()
    @State private var showingConfirmation = false
    @State private var confirmationCourse: Course?
    @State private var showingHistory = false

    var body: some View {
        let today = Calendar.current.startOfDay(for: Date())

        ScrollView {
            VStack(spacing: 20) {
                // Date Picker Section
                VStack(spacing: 10) {
                    DatePicker("Select Date", selection: $selectedDate, in: today...today, displayedComponents: .date)
                        .datePickerStyle(.graphical)

                    Button(action: { showingHistory.toggle() }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text(showingHistory ? "Hide Attendance History" : "Show Attendance History")
                        }
                        .font(.subheadline)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Attendance History
                if showingHistory {
                    VStack(alignment: .leading) {
                        Text("Attendance History")
                            .font(.headline)
                            .padding(.bottom, 5)

                        if attendances.isEmpty {
                            Text("No attendance records yet")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(attendances.prefix(5)) { attendance in
                                AttendanceHistoryRow(attendance: attendance)
                            }

                            if attendances.count > 5 {
                                NavigationLink(destination: FullAttendanceHistoryView()) {
                                    Text("View All (\(attendances.count))")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // Courses List
                if courses.isEmpty {
                    emptyCoursesView
                } else {
                    ForEach(courses) { course in
                        AttendanceCard(
                            course: course,
                            selectedDate: selectedDate,
                            isMarked: isAttendanceMarked(for: course, on: selectedDate),
                            onMarkAttendance: {
                                confirmationCourse = course
                                showingConfirmation = true
                            },
                            isToday: Calendar.current.isDateInToday(selectedDate)
                        )
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Attendance")
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

    private var emptyCoursesView: some View {
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
    }

    private func isAttendanceMarked(for course: Course, on date: Date) -> Bool {
        attendances.contains { attendance in
            attendance.course == course &&
            Calendar.current.isDate(attendance.date ?? Date(), inSameDayAs: date)
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

// MARK: - Attendance Card
struct AttendanceCard: View {
    let course: Course
    let selectedDate: Date
    let isMarked: Bool
    let onMarkAttendance: () -> Void
    let isToday: Bool

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
                if #available(iOS 15.0, *) {
                    Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }

                Spacer()

                Button(action: onMarkAttendance) {
                    HStack {
                        Image(systemName: isMarked ? "checkmark.circle.fill" : "checkmark")
                        Text(isMarked ? "Attendance Marked" : "Mark Present")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(isMarked || !isToday ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(isMarked || !isToday)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Attendance History Row
struct AttendanceHistoryRow: View {
    let attendance: Attendance

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(attendance.course?.name ?? "Unknown Course")
                    .font(.subheadline)
                if #available(iOS 15.0, *) {
                    Text(attendance.date.formatted(date: .abbreviated, time: .omitted) ?? "No date")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Text(attendance.status ?? "Unknown")
                .foregroundColor(attendance.status == "Present" ? .green : .red)
                .padding(5)
                .background(attendance.status == "Present" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(4)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Full Attendance History View
struct FullAttendanceHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.date, ascending: false)],
        animation: .default)
    private var attendances: FetchedResults<Attendance>

    var body: some View {
        List {
            ForEach(attendances) { attendance in
                AttendanceHistoryRow(attendance: attendance)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Attendance History")
        .navigationBarTitleDisplayMode(.inline)
    }
}
