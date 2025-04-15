import SwiftUI // Importing teh swift UI for making componenets
import CoreData // manage of teh database

struct AdminDashboardView: View { // decalring the main view for the admin dashboard
    @EnvironmentObject var authVM: AuthViewModel // take the access of authentication viue using enviroment
    @Environment(\.managedObjectContext) private var viewContext // getting the core data manage object context
    
    var body: some View { // main body view for this page
        TabView { // tablebar interface for table
            // Student Management for the first tab
            NavigationView {
                if #available(iOS 15, *) { // if the ios version runs or not
                    StudentManagementView() // if supported then show the studentmanagement
                } else {
                    // it will go back  on earlier versions
                }
            }
            .tabItem {
                Label("Students", systemImage: "person.3.fill") // add the tab label and icon of the system
            }
            
            // second tab Course Management
            NavigationView {
                CourseManagementView() // show the course management inside the a nav stack
            }
            .tabItem {
                Label("Courses", systemImage: "book.fill") // add the icon and lable
            }
            
            //  third panel for Admin Profile
            NavigationView {
                mainPrfole() // show the admin profile inside the nav stack
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill") // set the label icon and text
            }
        }
        .accentColor(.purple) // add the pruple as accent color
        .navigationBarTitle("Admin Dashboard", displayMode: .inline) // nav bar title
        .navigationBarItems(trailing: Button("Logout") { // adding the logout button to go back
            authVM.goBack() // go back way from to log out
        })
    }
}

struct mainPrfole: View { // main profile view
    @EnvironmentObject var authVM: AuthViewModel // access the shared authentication model
    
    var body: some View { // main view model
        VStack(spacing: 21) { // add the vertical layout and spacing
            Image(systemName: "person.crop.circle.fill") // adding the system icon
                .resizable() // make the icon resizeable
                .scaledToFit() // fitting the frame
                .frame(width: 119, height: 121) // add teh dimension
                .foregroundColor(.purple) // add color to the icon
                .padding(.top, 41) // set padding at the top
            
            Text("Administrator") // show the main icon as admin
                .font(.title)// add font size
                .fontWeight(.bold) // make the bold text
            
            Text("admin12@gmail.com") // show the predefined email
                .font(.subheadline) // add font to subheading style
                .foregroundColor(.gray) // make text as gray
            
            Spacer() // bring the content by adding space
        }
        .navigationTitle("Admin Profile") // set nav title for the view 
    }
}
