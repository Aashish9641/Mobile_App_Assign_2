import SwiftUI
import CoreData

// MARK: - Reusable Row View
struct rowIf: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.purple)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Main Course Management View
struct CourseManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default
    ) private var courses: FetchedResults<Course>
    
    @State private var searchText = ""
    @State private var showingAddCourse = false
    
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
                // Search Bar
                TextField("Search courses...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // List of Courses
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
                                    Label("Delete Course", systemImage: "trash")
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCourse = true
                    }) {
                        Label("Add", systemImage: "plus")
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
            try? viewContext.save()
        }
    }
}

// MARK: - Course Card
struct Cast: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "book.closed")
                .foregroundColor(.purple)
                .font(.system(size: 28))
                .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                Text(course.name ?? "Unknown")
                    .font(.headline)
                Text(course.code ?? "Code")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(course.schedule ?? "No schedule")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
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

    init(course: Course? = nil) {
        _name = State(initialValue: course?.name ?? "")
        _code = State(initialValue: course?.code ?? "")
        _schedule = State(initialValue: course?.schedule ?? "")
        self.course = course
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Details")) {
                    TextField("Course Name", text: $name)
                    TextField("Course Code", text: $code)
                    TextField("Schedule", text: $schedule)
                }

                Section {
                    Button(action: saveCourse) {
                        Text("Save Course")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(name.isEmpty || code.isEmpty)
                }
            }
            .navigationTitle(course == nil ? "Add Course" : "Edit Course")
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
        let target = course ?? Course(context: viewContext)
        target.name = name
        target.code = code
        target.schedule = schedule
        if course == nil {
            target.id = UUID()
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
    
    @State private var students: [Student] = []
    @State private var showingEditCourse = false
    @State private var showingDeleteConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Course Info")) {
                rowIf(icon: "book", label: "Name", value: course.name ?? "Unknown")
                rowIf(icon: "number", label: "Code", value: course.code ?? "No Code")
                rowIf(icon: "calendar", label: "Schedule", value: course.schedule ?? "N/A")
            }

            Section(header: Text("Students Enrolled")) {
                if students.isEmpty {
                    Text("No students enrolled")
                        .foregroundColor(.gray)
                } else {
                    ForEach(students, id: \.self) { student in
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)

                            VStack(alignment: .leading) {
                                Text(student.name ?? "Unknown")
                                    .font(.body)
                                Text(student.email ?? "No email")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Course Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingEditCourse = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .sheet(isPresented: $showingEditCourse) {
                    AddEditCourseView(course: course)
                        .environment(\.managedObjectContext, viewContext)
                }

                Button {
                    showingDeleteConfirmation = true
                } label: {
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
        .onAppear {
            fetchStudents()
        }
    }

    private func fetchStudents() {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.predicate = NSPredicate(format: "ANY courses == %@", course)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Student.name, ascending: true)]
        
        do {
            students = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch students: \(error.localizedDescription)")
        }
    }

    private func deleteCourse() {
        withAnimation {
            viewContext.delete(course)
            try? viewContext.save()
            presentationMode.wrappedValue.dismiss()
        }
    }
}
