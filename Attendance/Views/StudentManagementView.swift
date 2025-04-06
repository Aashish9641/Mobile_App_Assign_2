import SwiftUI
import CoreData

@available(iOS 15, *)
struct StudentManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authVM: AuthViewModel
    
    @FetchRequest(
        entity: Student.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default
    ) private var students: FetchedResults<Student>

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
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
}
