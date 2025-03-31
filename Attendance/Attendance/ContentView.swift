import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAdminLoggedIn = false
    @State private var isStudentLoggedIn = false
    
    var body: some View {
        Group {
            if isAdminLoggedIn {
                AdminDashboard(isAdminLoggedIn: $isAdminLoggedIn)
            } else if isStudentLoggedIn {
                HomeScreen()
            } else {
                AuthSelectionView(
                    isAdminLoggedIn: $isAdminLoggedIn,
                    isStudentLoggedIn: $isStudentLoggedIn
                )
            }
        }
        .environment(\.managedObjectContext, viewContext)
    }
}
