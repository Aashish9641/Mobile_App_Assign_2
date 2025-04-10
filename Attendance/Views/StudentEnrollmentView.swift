//import SwiftUI
//import CoreData
//
//struct StudentEnrollmentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @ObservedObject var course: Course
//    @State private var message: String?
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
//        animation: .default
//    ) private var allStudents: FetchedResults<Student>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(allStudents) { student in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(student.name ?? "Unknown")
//                                .font(.headline)
//                            Text(student.email ?? "No email")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                        Button {
//                            toggleEnrollment(for: student)
//                        } label: {
//                            Text(course.studentsArray.contains(student) ? "Unassign" : "Assign")
//                                .foregroundColor(.white)
//                                .padding(8)
//                                .background(course.studentsArray.contains(student) ? Color.red : Color.blue)
//                                .cornerRadius(8)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Enroll Students")
//            .overlay(
//                message.map {
//                    Text($0)
//                        .padding()
//                        .background(Color.accentColor)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                        .padding()
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                withAnimation {
//                                    message = nil
//                                }
//                            }
//                        }
//                }
//            )
//        }
//    }
//
//    private func toggleEnrollment(for student: Student) {
//        let isEnrolled = course.studentsArray.contains(student)
//
//        if isEnrolled {
//            student.safeRemoveCourse(course, context: viewContext)
//            message = "Student unassigned"
//        } else {
//            student.safeAddCourse(course, context: viewContext)
//            message = "Student assigned"
//        }
//
//        do {
//            try viewContext.save()
//        } catch {
//            message = "Failed to update enrollment"
//        }
//    }
//}
