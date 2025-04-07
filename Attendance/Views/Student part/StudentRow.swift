//// MARK: - StudentRow.swift
//import SwiftUI
//
//struct StudentRow: View {
//    let student: Student
//    let onEdit: () -> Void
//
//    var enrolledCoursesCount: Int {
//        student.courses?.count ?? 0
//    }
//
//    var body: some View {
//        HStack {
//            Image(systemName: "person.crop.circle.fill")
//                .font(.title2)
//                .foregroundColor(.blue)
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(student.name ?? "Unknown")
//                    .font(.headline)
//
//                Text(student.email ?? "No email")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            VStack {
//                Text("\(enrolledCoursesCount)")
//                    .font(.headline)
//                    .foregroundColor(.purple)
//                Text("Courses")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//
//            Button(action: onEdit) {
//                Image(systemName: "pencil")
//                    .foregroundColor(.blue)
//            }
//        }
//        .padding(.vertical, 8)
//    }
//}
