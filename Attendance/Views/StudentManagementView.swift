import SwiftUI
import CoreData

<<<<<<< HEAD
@available(iOS 15.0, *)
=======
@available(iOS 15, *)
>>>>>>> 2a48ba131fd0c861e3c1aa78510abad6e731a2c7
struct StudentManagementView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @FetchRequest(
        entity: Student.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default
    ) private var students: FetchedResults<Student>

<<<<<<< HEAD
    @State private var searchText = ""
    @State private var showingAddStudent = false
    @State private var editingStudent: Student?
    @State private var showDeleteAlert = false
    @State private var studentToDelete: Student?
    @State private var refreshID = UUID()

    var filteredStudents: [Student] {
        guard !searchText.isEmpty else { return Array(students) }
        return students.filter {
            $0.name?.lowercased().contains(searchText.lowercased()) ?? false ||
            $0.email?.lowercased().contains(searchText.lowercased()) ?? false
=======
    @State private var showingAddStudent = false
    @State private var editingStudent: Student?
    @State private var searchText = ""
    @State private var showSuccessAlert = false
    @State private var successMessage = ""
    
    // Filtering logic based on search text
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return Array(students) // Return all students if no search text
        } else {
            return students.filter { student in
                let nameMatches = student.name?.lowercased().contains(searchText.lowercased()) ?? false
                let emailMatches = student.email?.lowercased().contains(searchText.lowercased()) ?? false
                return nameMatches || emailMatches
            }
>>>>>>> 2a48ba131fd0c861e3c1aa78510abad6e731a2c7
        }
    }

    var body: some View {
        NavigationView {
            VStack {
<<<<<<< HEAD
                if students.isEmpty {
                    Spacer()
                    Text("No Students Found")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredStudents, id: \.self) { student in
                                studentRow(for: student)
                            }
                        }
                        .padding(.top)
                    }
                    .searchable(text: $searchText)
                    .id(refreshID)
                }
            }
            .padding()
            .navigationTitle("🎓 Student Management")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddStudent) {
                AddEditStudentView(onSave: refreshList)
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(item: $editingStudent) { student in
                AddEditStudentView(student: student, onSave: refreshList)
                    .environment(\.managedObjectContext, viewContext)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Student"),
                    message: Text("Are you sure you want to delete \(studentToDelete?.name ?? "this student")?"),
                    primaryButton: .destructive(Text("Delete"), action: confirmDelete),
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(.stack) // Fullscreen on iPhone/iPad
    }

    // MARK: - Student Row

    private func studentRow(for student: Student) -> some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 6) {
                    Text(student.name ?? "Unknown Student")
                        .font(.headline)
                    Text(student.email ?? "No email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                NavigationLink(destination: CourseEnrollmentView(student: student)) {
                    VStack(spacing: 2) {
                        Text("\(student.courses?.count ?? 0)")
                            .font(.headline)
                            .foregroundColor(.purple)
                        Text("Courses")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                HStack(spacing: 12) {
                    Button(action: { editStudent(student) }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.orange)
                            .imageScale(.large)
                    }

                    Button(action: { confirmDelete(student) }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
        }
    }

    // MARK: - Actions

    private func editStudent(_ student: Student) {
        editingStudent = student
    }

    private func confirmDelete(_ student: Student) {
        studentToDelete = student
        showDeleteAlert = true
    }

    private func confirmDelete() {
        guard let student = studentToDelete else { return }

        withAnimation {
            viewContext.delete(student)
            do {
                try viewContext.save()
                refreshList()
            } catch {
                print("Error deleting student: \(error.localizedDescription)")
            }
        }
    }

    private func refreshList() {
        refreshID = UUID()
    }
=======
                // Search Bar with added padding for better visibility
                SearchBar(text: $searchText)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                List {
                    ForEach(filteredStudents, id: \.self) { student in
                        HStack {
                            // Better presentation of student data in a vertical stack
                            VStack(alignment: .leading) {
                                Text(student.name ?? "Unnamed")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(student.email ?? "No Email")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            // Action buttons for Edit and Delete with separate actions
                            VStack(spacing: 10) {
                                Button(action: {
                                    editStudent(student) // Edit action
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .background(Circle().fill(Color.blue.opacity(0.2)))
                                        .shadow(radius: 3)
                                }
                                
                                Button(role: .destructive, action: {
                                    deleteStudent(student) // Delete action
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(10)
                                        .background(Circle().fill(Color.red.opacity(0.2)))
                                        .shadow(radius: 3)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 2))
                        .padding(.horizontal)
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.top, 10)
            }
            .navigationTitle("Student Management")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddStudent = true // Show Add Student view
                    } label: {
                        Label("Add Student", systemImage: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddStudent) {
                AddEditStudentView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(item: $editingStudent) { student in
                AddEditStudentView(student: student) // Show Edit view for selected student
                    .environment(\.managedObjectContext, viewContext)
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(successMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Separate edit function for the student
    private func editStudent(_ student: Student) {
        editingStudent = student // Trigger sheet to edit the selected student
    }

    // Separate delete function for the student
    private func deleteStudent(_ student: Student) {
        withAnimation {
            viewContext.delete(student)
            PersistenceController.shared.save()
            successMessage = "Student deleted successfully"
            showSuccessAlert = true
        }
    }
>>>>>>> 2a48ba131fd0c861e3c1aa78510abad6e731a2c7
}
