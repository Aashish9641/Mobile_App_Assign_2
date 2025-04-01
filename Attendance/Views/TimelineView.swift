// MARK: - 📂 Views/TimelineView.swift
import SwiftUI
import CoreData

struct TimelineView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject var postVM = PostViewModel()
    @State private var newPost = ""
    @State private var postType: PostType = .global
    
    enum PostType { case global, course }
    
    var body: some View {
        VStack {
            Picker("Post Type", selection: $postType) {
                Text("Global").tag(PostType.global)
                Text("Course").tag(PostType.course)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TextEditor(text: $newPost)
                .frame(height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                guard let student = authVM.currentStudent else { return }
                postVM.createPost(
                    content: newPost,
                    isGlobal: postType == .global,
                    course: nil,
                    author: student
                )
                newPost = ""
            }) {
                Text("Post")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            List(postVM.fetchPosts()) { post in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(post.author?.name ?? "Unknown")
                            .fontWeight(.bold)
                        Spacer()
                        Text(formattedDate(post.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(post.content ?? "")
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("University Timeline")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
