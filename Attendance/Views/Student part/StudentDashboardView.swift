import SwiftUI // Importinmg the swift UI for manageing teh Swift part
struct StudentDashboardView: View { // this is the main dashboard for the students
    @EnvironmentObject var authVM: AuthViewModel // Accessing the view model of authentication
    
    var body: some View { // add view for body section
        TabView { // made the tab based interface in UI
            // adding the home tab
            NavigationView { // add nav view to go to another part
                mainStude() // fix the custom view for the major panel
                    .navigationBarItems(trailing: butLogo) // add logout button in nav bar
            }
            .tabItem { // add tab parts
                Label("Home", systemImage: "house.fill") // add the table icon and label
            }
            
            // Adding the Attendance section
            NavigationView { // inilize the nav view
                AttendanceView() // nav go to attendance screen
                    .navigationBarItems(trailing: butLogo) // add the logout button here
            }
            .tabItem { // add tab items
                Label("Attendance", systemImage: "checkmark.circle.fill") // linking the label and icon
            }
            
            // added the timeline tab as well
            NavigationView { // add nav bar view
                if #available(iOS 15.0, *) { // make sure the timeline runs in IOS 15
                    TimelineView() // add timeline for post operation
                        .navigationBarItems(trailing: butLogo) // added the logout button
                } else {
                    // it will fallb ack in IOS version
                }
            }
            .tabItem { // also linked tab items as timline
                Label("Timeline", systemImage: "message.fill") // linked label and icon for this
            }
            
            // another profile tab
            NavigationView { // add navigation containmer for stack
                if #available(iOS 15.0, *) { // make sure to run in ios 15
                    StudentProfileView() // viewing the profile of students
                        .navigationBarItems(trailing: butLogo) // again added the button for logout
                } else {
                    // go back of Ios earlier version
                }
            }
            .tabItem { // tab items linked
                Label("Profile", systemImage: "person.fill") // added label of profile and icon
            }
        }
        .accentColor(.blue) // making accent color as blue
    }
    
    // elements of logout buttons
    private var butLogo: some View {
        Button(action: { // added action for logout button
            authVM.goBack() // calling the nav back mechanism
        }) {
            Text("Logout") // added logout text
                .foregroundColor(.red) // Text would be in red color
        }
    }
}

struct mainStude: View { // main home screen view for students
    @EnvironmentObject var authVM: AuthViewModel // get the access of authentication view model
    @Environment(\.managedObjectContext) private var viewContext // added the concept of core data
    
    @FetchRequest( // fetching the list of the course sorted by name
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)], // sorted by name in ascending order
        animation: .default) // add animation as default
    private var courses: FetchedResults<Course> // consequence of the fetch
    
    var body: some View { // var body view
        ScrollView { // allowing the vertical side scrolling
            VStack(spacing: 21) {
                // custom for welcome header panel
                VStack(spacing: 11) { // add vertical side stack space
                    Text(" Hey Welcome back,") // welcome text for the students
                        .font(.title2) //add font title 2
                        .foregroundColor(.gray) // set the BG color as gray
                    
                    Text(authVM.studeRight?.name ?? "Student") // dispaly the name of studnet with message
                        .font(.title) // added font title
                        .fontWeight(.bold) // making it bold as well
                }
                .padding(.top, 20) // set padding in top side
                
                // Fast action buttons
                HStack(spacing: 15) { // horizontal layout spacing
                    NavigationLink(destination: AttendanceView()) { // linking with the attendance screen
                        buttFast(imgs: "checkmark.circle.fill", llba: "Mark Attendance", color: .blue) // adding the icon and color for the label
                    }
                    
                    if #available(iOS 15.0, *) { // make sure to run time view in ios 15
                        NavigationLink(destination: TimelineView()) { // linking with the time line screen to make it better
                            buttFast(imgs: "message.fill", llba: "Post Update", color: .green)
                        }
                    } else {
                        // to to another version of ios
                    };if #available(iOS 15.0, *) { // make sure to run time view in ios 15
                        NavigationLink(destination: TimelineView()) { // add to timeline view
                            buttFast(imgs: "message.fill", llba: "Post Update", color: .green)
                        }
                    } else {
                        // to to another version of ios
                    }
                }
                .padding(.horizontal) // add padding in horizontal side
                
                // course panel
                VStack(alignment: .leading) { // add alignment in vertical part
                    Text("Current Courses") // display the text as courses
                        .font(.headline) // add font headline
                        .padding(.horizontal) // declare the padding in H side
                    
                    if courses.isEmpty { // run  if the course is empty
                        Text("No courses has been enrolled ") // show this message if course is not present
                            .foregroundColor(.gray) // add gray color as foreground
                            .padding() // add required padding
                    } else {
                        ForEach(courses) { course in // code of loop through in each course
                            cardC(course: course) // add the custom card view
                        }
                    }
                }
                
                Spacer() // bring the content to the top side
            }
        }
        .navigationTitle("Home") // add title in top of the screen
    }
}
// action button for UI elements
struct buttFast: View {
    let imgs: String // icon name
    let llba: String // text label
    let color: Color // add color
    
    var body: some View { // view body var
        VStack { // added the vertical stack
            Image(systemName: imgs) // added the system icon
                .font(.title) // added font title
                .padding() // add necessay padding
                .background(color.opacity(0.3)) // add background and opacity as well
                .foregroundColor(color) // add font color as gray
                .clipShape(Circle()) // make the content in circular shape
            
            Text(llba) // labeling the text
                .font(.caption) // font text
                .multilineTextAlignment(.center) // making it in in center
        }
        .frame(width: 99, height: 101) // making the frame size
        .background(Color(.secondarySystemBackground)) // light background color
        .cornerRadius(16) // add teh corner radius as well
    }
}

struct cardC: View { // UI elements of courses
    let course: Course // add the courses model
    
    var body: some View { // add var body view
        HStack { // horizontal stack added
            Image(systemName: "book.closed.fill") // add the icon of the book
                .font(.title) // fixing the font size
                .foregroundColor(.purple) // fix purple color
                .padding(.trailing, 11) // space between icon and text
            
            VStack(alignment: .leading, spacing: 5) { // fixing the alignment
                Text(course.name ?? "Unknown Course") // add the name of course
                    .font(.headline) // added the font heading
                
                Text(course.schedule ?? "No schedule") // course shedule added
                    .font(.subheadline) // link the subheading
                    .foregroundColor(.gray) // declare color as gray
            }
            
            Spacer() // bring the icon to right side
            
            Image(systemName: "chevron.right") // added the icon arrow
                .foregroundColor(.gray) // addded the color as gray as well
        }
        .padding() // fix the rewuired padding
        .background(Color(.secondarySystemBackground)) // adding card BG
        .cornerRadius(11) // link cornder radious
        .padding(.horizontal) // outer padding in horizontal side 
    }
}
