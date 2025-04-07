//import SwiftUI
//import CoreData
//
//struct ReportsView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
//        animation: .default)
//    private var courses: FetchedResults<Course>
//
//    @State private var selectedCourse: Course?
//    @State private var selectedTimePeriod: TimePeriod = .thisWeek
//
//    enum TimePeriod: String, CaseIterable {
//        case today = "Today"
//        case thisWeek = "This Week"
//        case thisMonth = "This Month"
//        case allTime = "All Time"
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // Filters
//            VStack(spacing: 15) {
//                Picker("Time Period", selection: $selectedTimePeriod) {
//                    ForEach(TimePeriod.allCases, id: \.self) { period in
//                        Text(period.rawValue).tag(period)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//
//                if courses.isEmpty {
//                    Text("No courses available")
//                        .foregroundColor(.gray)
//                } else {
//                    Picker("Course", selection: $selectedCourse) {
//                        Text("All Courses").tag(nil as Course?)
//                        ForEach(courses) { course in
//                            Text(course.name ?? "Unknown Course").tag(course as Course?)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//            }
//            .padding()
//
//            Divider()
//
//            // Report Content
//            if let course = selectedCourse {
//                CourseAttendanceReport(course: course, timePeriod: selectedTimePeriod)
//            } else {
//                OverallAttendanceReport(timePeriod: selectedTimePeriod)
//            }
//
//            Spacer()
//        }
//        .navigationTitle("Attendance Reports")
//    }
//}
//
//struct CourseAttendanceReport: View {
//    let course: Course
//    let timePeriod: ReportsView.TimePeriod
//
//    var fetchRequest: FetchRequest<Attendance>
//    var attendanceRecords: FetchedResults<Attendance> { fetchRequest.wrappedValue }
//
//    init(course: Course, timePeriod: ReportsView.TimePeriod) {
//        self.course = course
//        self.timePeriod = timePeriod
//
//        let request = NSFetchRequest<Attendance>(entityName: "Attendance")
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Attendance.date, ascending: false)]
//        request.predicate = NSPredicate(format: "course == %@", course)
//
//        switch timePeriod {
//        case .today:
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
//            ])
//        case .thisWeek:
//            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", startOfWeek as NSDate)
//            ])
//        case .thisMonth:
//            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", startOfMonth as NSDate)
//            ])
//        case .allTime:
//            request.predicate = NSPredicate(format: "course == %@", course)
//        }
//
//        fetchRequest = FetchRequest(fetchRequest: request)
//    }
//
//    var body: some View {
//        VStack(spacing: 15) {
//            // Summary Stats
//            HStack(spacing: 15) {
//                StatCard(value: "\(attendanceRecords.count)", label: "Total", icon: "checkmark.circle.fill", color: .green)
//                StatCard(value: "\(uniqueStudents.count)", label: "Students", icon: "person.2.fill", color: .blue)
//                StatCard(value: "\(attendanceRate)", label: "Attendance Rate", icon: "chart.bar.fill", color: .purple)
//            }
//            .padding(.horizontal)
//
//            // Attendance List
//            List {
//                Section(header: Text("Recent Attendance")) {
//                    if attendanceRecords.isEmpty {
//                        Text("No attendance records")
//                            .foregroundColor(.gray)
//                    } else {
//                        ForEach(attendanceRecords) { record in
//                            HStack {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(record.student?.name ?? "Unknown")
//                                        .font(.headline)
//
//                                    Text(formattedDate(record.date ?? Date()))
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//
//                                Spacer()
//
//                                Text(record.status ?? "Present")
//                                    .foregroundColor(.green)
//                            }
//                        }
//                    }
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//
//    private var uniqueStudents: [Student] {
//        var students = [Student]()
//        for record in attendanceRecords {
//            if let student = record.student, !students.contains(where: { $0.id == student.id }) {
//                students.append(student)
//            }
//        }
//        return students
//    }
//
//    private var attendanceRate: String {
//        guard let allStudents = course.students, !allStudents.isEmpty else {
//            return "0%"
//        }
//
//        let presentCount = uniqueStudents.count
//        let totalCount = allStudents.count
//        let rate = Double(presentCount) / Double(totalCount) * 100
//
//        return String(format: "%.1f%%", rate)
//    }
//}
//
//struct OverallAttendanceReport: View {
//    let timePeriod: ReportsView.TimePeriod
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
//        animation: .default)
//    private var courses: FetchedResults<Course>
//
//    init(timePeriod: ReportsView.TimePeriod) {
//        self.timePeriod = timePeriod
//    }
//
//    var body: some View {
//        VStack(spacing: 15) {
//            // Summary Stats
//            HStack(spacing: 15) {
//                StatCard(value: "\(totalAttendance)", label: "Total", icon: "checkmark.circle.fill", color: .green)
//                StatCard(value: "\(courses.count)", label: "Courses", icon: "book.fill", color: .blue)
//                StatCard(value: "\(totalStudents)", label: "Students", icon: "person.2.fill", color: .purple)
//            }
//            .padding(.horizontal)
//
//            // Course Attendance Chart
//            BarChartView(data: courseAttendanceData)
//                .frame(height: 200)
//                .padding(.horizontal)
//
//            // Course List
//            List {
//                Section(header: Text("Courses")) {
//                    ForEach(courses) { course in
//                        NavigationLink(destination: CourseAttendanceReport(course: course, timePeriod: timePeriod)) {
//                            HStack {
//                                Text(course.name ?? "Unknown")
//                                Spacer()
//                                Text("\(attendanceCount(for: course))")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//
//    private var totalAttendance: Int {
//        courses.reduce(0) { total, course in
//            total + attendanceCount(for: course)
//        }
//    }
//
//    private var totalStudents: Int {
//        var students = Set<UUID>()
//        for course in courses {
//            if let courseStudents = course.students {
//                for student in courseStudents {
//                    if let student = student as? Student {
//                        students.insert(student.id ?? UUID())
//                    }
//                }
//            }
//        }
//        return students.count
//    }
//
//    private func attendanceCount(for course: Course) -> Int {
//        let request = NSFetchRequest<Attendance>(entityName: "Attendance")
//        request.predicate = NSPredicate(format: "course == %@", course)
//
//        switch timePeriod {
//        case .today:
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
//            ])
//        case .thisWeek:
//            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", startOfWeek as NSDate)
//            ])
//        case .thisMonth:
//            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                NSPredicate(format: "course == %@", course),
//                NSPredicate(format: "date >= %@", startOfMonth as NSDate)
//            ])
//        case .allTime:
//            request.predicate = NSPredicate(format: "course == %@", course)
//        }
//
//        do {
//            return try PersistenceController.shared.container.viewContext.count(for: request)
//        } catch {
//            return 0
//        }
//    }
//
//    private var courseAttendanceData: [BarChartData] {
//        courses.prefix(5).map { course in
//            BarChartData(
//                label: course.name ?? "Course",
//                value: Double(attendanceCount(for: course)),
//                color: .purple
//            )
//        }
//    }
//}
//
//struct StatCard: View {
//    let value: String
//    let label: String
//    let icon: String
//    let color: Color
//
//    var body: some View {
//        VStack(spacing: 8) {
//            HStack(spacing: 5) {
//                Image(systemName: icon)
//                    .foregroundColor(color)
//
//                Text(value)
//                    .font(.system(size: 18, weight: .bold))
//            }
//
//            Text(label)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(10)
//    }
//}
//
//struct BarChartData {
//    let label: String
//    let value: Double
//    let color: Color
//}
//
//struct BarChartView: View {
//    let data: [BarChartData]
//
//    private var maxValue: Double {
//        data.map { $0.value }.max() ?? 1
//    }
//
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack(alignment: .bottom, spacing: 10) {
//                ForEach(data.indices, id: \.self) { index in
//                    VStack(spacing: 5) {
//                        Text(String(format: "%.0f", data[index].value))
//                            .font(.caption)
//
//                        Rectangle()
//                            .fill(data[index].color)
//                            .frame(height: CGFloat(data[index].value / maxValue * 150))
//
//                        Text(data[index].label)
//                            .font(.caption2)
//                            .frame(height: 30)
//                            .multilineTextAlignment(.center)
//                    }
//                }
//            }
//        }
//    }
//}
