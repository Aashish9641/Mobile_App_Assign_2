// MARK: - AdminDashboardView.swift
import SwiftUI
import CoreData

struct AdminDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default)
    private var students: FetchedResults<Student>
    
    @State private var showingAddStudent = false
    @State private var editingStudent: Student?
    @State private var showingEnrollmentSheet = false
    @State private var selectedStudent: Student?
    
    var body: some View {
        TabView {
            // Student Management Tab
            NavigationView {
                VStack {
                    // Student Table
                    List {
                        // Table Header
                        HStack {
                            Text("Name").frame(width: 120, alignment: .leading)
                            Text("Email").frame(maxWidth: .infinity, alignment: .leading)
                            Text("Actions").frame(width: 150, alignment: .trailing)
                        }
                        .font(.headline)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        
                        // Table Rows
                        ForEach(students) { student in
                            HStack {
                                Text(student.name ?? "Unknown")
                                    .frame(width: 120, alignment: .leading)
                                
                                Text(student.email ?? "No email")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 10) {
                                    // Edit Button
                                    Button(action: {
                                        editingStudent = student
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    // Enroll Button
                                    Button(action: {
                                        selectedStudent = student
                                        showingEnrollmentSheet = true
                                    }) {
                                        Image(systemName: "book")
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    // Delete Button
                                    Button(action: {
                                        deleteStudent(student)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                .frame(width: 150, alignment: .trailing)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showingAddStudent = true }) {
                            Label("Add Student", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddStudent) {
                    AddStudentView()
                        .environment(\.managedObjectContext, viewContext)
                }
                .sheet(item: $editingStudent) { student in
                    EditStudentView(student: student)
                        .environment(\.managedObjectContext, viewContext)
                }
                .sheet(isPresented: $showingEnrollmentSheet) {
                    if let student = selectedStudent {
                        CourseEnrollmentView(student: student)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
                .navigationTitle("Student Management")
            }
            .tabItem {
                Label("Students", systemImage: "person.3.fill")
            }
            
            // Course Management Tab
            NavigationView {
                CourseManagementView()
            }
            .tabItem {
                Label("Courses", systemImage: "book.fill")
            }
        }
        .accentColor(.purple)
    }
    
    private func deleteStudent(_ student: Student) {
        withAnimation {
            viewContext.delete(student)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
