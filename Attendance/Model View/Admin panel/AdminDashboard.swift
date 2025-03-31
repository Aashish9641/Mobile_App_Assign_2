struct AdminDashboard: View {
    @Binding var isAdminLoggedIn: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            // Students Management
            NavigationView {
                StudentListView()
            }
            .tabItem {
                Label("Students", systemImage: "person.3")
            }
            
            // Courses Management
            NavigationView {
                CourseListView()
            }
            .tabItem {
                Label("Courses", systemImage: "book")
            }
            
            // Reports
            NavigationView {
                AttendanceReportsView()
            }
            .tabItem {
                Label("Reports", systemImage: "chart.bar")
            }
        }
        .navigationBarItems(trailing: Button("Logout") {
            isAdminLoggedIn = false
        })
    }
}
