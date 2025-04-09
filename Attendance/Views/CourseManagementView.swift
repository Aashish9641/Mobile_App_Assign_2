import SwiftUI
import CoreData

// MARK: - rowIf View
struct rowIf: View {
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

// MARK: - Main Course Management View
struct CourseManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authVM: AuthViewModel
    
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var courses: FetchedResults<Course>
    
    @State private var showingAddCourse = false
    @State private var searchText = ""

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return Array(courses)
        } else {
            return courses.filter { course in
                (course.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (course.code?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                List {
                    ForEach(filteredCourses, id: \.self) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            Cast(course: course)
                        }
                        .contextMenu {
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive) {
                                    deleteCourse(course)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } else {
                                Button {
                                    deleteCourse(course)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddCourse = true
                    } label: {
                        Label("Add Course", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCourse) {
                AddEditCourseView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteCourse(_ course: Course) {
        withAnimation {
            viewContext.delete(course)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting course: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Course Row View
struct Cast: View {
    let course: Course
    
    var body: some View {
        HStack {
            Image(systemName: "book.closed.fill")
                .font(.title2)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.name ?? "Unknown Course")
                    .font(.headline)
                
                HStack(spacing: 15) {
                    Text(course.code ?? "No code")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(course.schedule ?? "No schedule")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Add/Edit Course View
struct AddEditCourseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String
    @State private var code: String
    @State private var schedule: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var course: Course?

    // Initialize with an optional course
    init(course: Course? = nil) {
        _name = State(initialValue: course?.name ?? "")
        _code = State(initialValue: course?.code ?? "")
        _schedule = State(initialValue: course?.schedule ?? "")
        self.course = course
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Information")) {
                    TextField("Course Name", text: $name)
                    TextField("Course Code", text: $code)
                    TextField("Schedule (e.g., Mon/Wed 10-11:30)", text: $schedule)
                }
                
                Section {
                    Button("Save Course") {
                        saveCourse()
                    }
                    .disabled(name.isEmpty || code.isEmpty)
                }
            }
            .navigationTitle(course == nil ? "New Course" : "Edit Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveCourse() {
        if let course = course {
            course.name = name
            course.code = code
            course.schedule = schedule
        } else {
            let newCourse = Course(context: viewContext)
            newCourse.id = UUID()
            newCourse.name = name
            newCourse.code = code
            newCourse.schedule = schedule
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "Failed to save course: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

// MARK: - Course Detail View
struct CourseDetailView: View {
    @ObservedObject var course: Course
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var students: [Student] {
        guard let studentSet = course.students as? Set<Student> else { return [] }
        return Array(studentSet).sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    @State private var showingEditCourse = false
    @State private var showingDeleteConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Course Information")) {
                rowIf(icon: "text.book.closed", label: "Name", value: course.name ?? "Unknown")
                rowIf(icon: "number", label: "Code", value: course.code ?? "No code")
                rowIf(icon: "calendar", label: "Schedule", value: course.schedule ?? "No schedule")
            }

            Section(header: Text("Enrolled Students")) {
                if students.isEmpty {
                    Text("No students enrolled")
                        .foregroundColor(.gray)
                } else {
                    ForEach(students, id: \.self) { student in
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundColor(.blue)

                            VStack(alignment: .leading) {
                                Text(student.name ?? "Unknown")
                                    .font(.headline)
                                Text(student.email ?? "No email")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEditCourse = true
                }) {
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $showingEditCourse) {
                    AddEditCourseView(course: course)
                        .environment(\.managedObjectContext, viewContext)
                }

                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Course"),
                message: Text("Are you sure you want to delete this course?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteCourse()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func deleteCourse() {
        withAnimation {
            viewContext.delete(course)
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error deleting course: \(error.localizedDescription)")
            }
        }
    }
}
