import SwiftUI
import CoreData

@available(iOS 15.0, *)
struct TimelineView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newPost = ""
    @State private var postType: PostType = .global
    @State private var selectedCourse: Course?
    @State private var showingCoursePicker = false
    
    enum PostType { case global, course }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Post.timestamp, ascending: false)],
        animation: .default)
    private var posts: FetchedResults<Post>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    var filteredPosts: [Post] {
        switch postType {
        case .global:
            return posts.filter { $0.isGlobal }
        case .course:
            if let course = selectedCourse {
                return posts.filter { $0.course == course }
            }
            return []
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 15) {
                Picker("Post Type", selection: $postType) {
                    Text("Global").tag(PostType.global)
                    Text("Course").tag(PostType.course)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if postType == .course {
                    Button {
                        showingCoursePicker = true
                    } label: {
                        HStack {
                            Text(selectedCourse?.name ?? "Select Course")
                                .foregroundColor(selectedCourse == nil ? .gray : .primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                TextEditor(text: $newPost)
                    .frame(height: 100)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Button {
                    createPost()
                } label: {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Post")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(newPost.isEmpty || (postType == .course && selectedCourse == nil))
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .sheet(isPresented: $showingCoursePicker) {
                CourseSelectionView(selectedCourse: $selectedCourse)
            }
            
            Divider()
            
            List {
                if filteredPosts.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text(postType == .global ? "No global posts yet" : "No posts for this course yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Be the first to post!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(filteredPosts) { post in
                        PostView(post: post)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(postType == .global ? "Global Timeline" : "Course Timeline")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func createPost() {
        guard let student = authVM.currentStudent else { return }
        
        let post = Post(context: viewContext)
        post.id = UUID()
        post.content = newPost
        post.timestamp = Date()
        post.isGlobal = postType == .global
        post.author = student
        post.course = postType == .course ? selectedCourse : nil
        
        PersistenceController.shared.save()
        newPost = ""
    }
}

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(post.author?.name ?? "Unknown")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if let course = post.course, !post.isGlobal {
                            Text("·")
                            Text(course.name ?? "Course")
                                .font(.caption)
                                .foregroundColor(.purple)
                                .padding(4)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(formattedDate(date: post.timestamp ?? Date()))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text(post.content ?? "")
                .padding(.leading, 35)
            
            HStack(spacing: 20) {
                Button {
                    // Like action
                } label: {
                    HStack {
                        Image(systemName: "heart")
                        Text("Like")
                    }
                    .font(.caption)
                }
                
                Button {
                    // Comment action
                } label: {
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("Comment")
                    }
                    .font(.caption)
                }
                
                Spacer()
            }
            .padding(.leading, 35)
            .padding(.top, 5)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct CourseSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCourse: Course?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(courses) { course in
                    Button {
                        selectedCourse = course
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Text(course.name ?? "Unknown Course")
                            Spacer()
                            if course == selectedCourse {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
