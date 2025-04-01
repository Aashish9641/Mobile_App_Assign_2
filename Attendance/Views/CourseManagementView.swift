// MARK: - CourseManagementView.swift
import SwiftUI
import CoreData

struct CourseManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    @State private var showingAddCourse = false
    
    var body: some View {
        List {
            ForEach(courses) { course in
                NavigationLink(destination: CourseDetailView(course: course)) {
                    HStack {
                        Image(systemName: "book.closed.fill")
                            .foregroundColor(.purple)
                        VStack(alignment: .leading) {
                            Text(course.name ?? "Unknown Course")
                                .font(.headline)
                            Text(course.code ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onDelete(perform: deleteCourses)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddCourse = true }) {
                    Label("Add Course", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCourse) {
            AddCourseView()
                .environment(\.managedObjectContext, viewContext)
        }
        .navigationTitle("Course Management")
    }
    
    private func deleteCourses(at offsets: IndexSet) {
        // Create a separate array to avoid compiler issues
        let coursesToDelete = offsets.map { courses[$0] }
        
        withAnimation {
            coursesToDelete.forEach { course in
                viewContext.delete(course)
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
                // Handle the error appropriately in your UI
            }
        }
    }
}

struct CourseDetailView: View {
    @ObservedObject var course: Course
    
    var body: some View {
        Form {
            Section(header: Text("Course Information")) {
                Text(course.name ?? "Unknown")
                Text(course.code ?? "")
                Text(course.schedule ?? "No schedule set")
            }
            
            Section(header: Text("Enrolled Students")) {
                if let studentsSet = course.students as? Set<Student>, !studentsSet.isEmpty {
                    ForEach(Array(studentsSet), id: \.self) { student in
                        Text(student.name ?? "Unknown Student")
                    }
                } else {
                    Text("No students enrolled")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Course Details")
    }
}

struct AddCourseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var code = ""
    @State private var schedule = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Details")) {
                    TextField("Course Name", text: $name)
                    TextField("Course Code", text: $code)
                    TextField("Schedule", text: $schedule)
                }
            }
            .navigationTitle("New Course")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    addCourse()
                }
                .disabled(name.isEmpty || code.isEmpty)
            )
        }
    }
    
    private func addCourse() {
        let newCourse = Course(context: viewContext)
        newCourse.id = UUID()
        newCourse.name = name
        newCourse.code = code
        newCourse.schedule = schedule
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save course: \(error.localizedDescription)")
        }
    }
}
