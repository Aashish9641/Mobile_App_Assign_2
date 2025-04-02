import SwiftUI
import CoreData

struct StudentManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authVM: AuthViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default)
    private var students: FetchedResults<Student>
    
    @State private var showingAddStudent = false
    @State private var editingStudent: Student?
    @State private var searchText = ""
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return Array(students)
        } else {
            return students.filter { student in
                (student.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (student.email?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.horizontal)
            
            List {
                ForEach(filteredStudents, id: \.self) { student in
                    StudentRow(student: student) {
                        editingStudent = student
                    }
                    .contextMenu {
                        Button {
                            editingStudent = student
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        if #available(iOS 15.0, *) {
                            Button(role: .destructive) {
                                deleteStudent(student)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } else {
                            Button {
                                deleteStudent(student)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddStudent = true
                } label: {
                    Label("Add Student", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddStudent) {
            AddEditStudentView()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(item: $editingStudent) { student in
            AddEditStudentView(student: student)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func deleteStudent(_ student: Student) {
        withAnimation {
            viewContext.delete(student)
            PersistenceController.shared.save()
        }
    }
}

struct StudentRow: View {
    let student: Student
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name ?? "Unknown")
                    .font(.headline)
                
                Text(student.email ?? "No email")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}
