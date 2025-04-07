import SwiftUI
import CoreData

@available(iOS 15.0, *)
struct StudentManagementView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default
    ) private var students: FetchedResults<Student>

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
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredStudents, id: \.self) { student in
                        studentRow(for: student)
                    }
                }
                .searchable(text: $searchText)
                .id(refreshID)
            }
            .navigationTitle("Student Management")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "plus")
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
    }

    // MARK: - Student Row

    private func studentRow(for student: Student) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(student.name ?? "Unknown Student")
                    .font(.headline)
                Text(student.email ?? "No email")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Navigate to Course Assignment View
            NavigationLink(destination: CourseEnrollmentView(student: student)) {
                VStack {
                    Text("\(student.courses?.count ?? 0)")
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text("Courses")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: { editStudent(student) }) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())

            Button(action: { confirmDelete(student) }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
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
}
