// MARK: - 📂 ViewModels/PostViewModel.swift
import SwiftUI
import CoreData

class PostViewModel: ObservableObject {
    private let context = PersistenceController.shared.container.viewContext
    
    func createPost(content: String, isGlobal: Bool, course: Course?, author: Student) {
        let post = Post(context: context)
        post.id = UUID()
        post.content = content
        post.timestamp = Date()
        post.isGlobal = isGlobal
        post.author = author
        post.course = course
        PersistenceController.shared.save()
    }
    
    func fetchPosts(for course: Course? = nil) -> [Post] {
        let request = NSFetchRequest<Post>(entityName: "Post")
        if let course = course {
            request.predicate = NSPredicate(format: "course == %@", course)
        } else {
            request.predicate = NSPredicate(format: "isGlobal == true")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
}
