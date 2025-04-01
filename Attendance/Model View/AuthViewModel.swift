// MARK: - 📂 ViewModels/AuthViewModel.swift
import SwiftUI
import CoreData
import CryptoKit

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var currentStudent: Student?
    
    private let context = PersistenceController.shared.container.viewContext
    
    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func login(email: String, password: String) {
        if email == "admin12@gmail.com" && password == "admin123" {
            isAdmin = true
            isAuthenticated = true
            return
        }
        
        let hashedPassword = hashPassword(password)
        let request = NSFetchRequest<Student>(entityName: "Student")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, hashedPassword)
        
        do {
            let students = try context.fetch(request)
            if let student = students.first {
                currentStudent = student
                isAuthenticated = true
            }
        } catch {
            print("Login error: \(error)")
        }
    }
    
    func logout() {
        isAuthenticated = false
        isAdmin = false
        currentStudent = nil
    }
}
