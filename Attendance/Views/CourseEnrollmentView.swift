import SwiftUI // Import the swift UI for building UI
import CoreData // management of the dabatase

struct CourseEnrollmentView: View { // Major view for enrolling a students in courses
    @Environment(\.managedObjectContext) private var viewContext // view context for the core data
    @ObservedObject var student: Student // right now studnet when course  are editing
    @State private var alert: String? = nil // to dispaly the success or error message

    @FetchRequest( // fecthing the course from datbase b
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default // add animation sorted by name and ascending order
    ) private var eveyCo: FetchedResults<Course> // result of the fetch request
    
    @State private var enrollmentStatus: [UUID: Bool] = [:]  // Store  all the status by course ID who are enrolled in

    var body: some View { // main body view section
        NavigationView { // nav view
            VStack {
                List { // list of the courses
                    ForEach(eveyCo) { course in // using for each loop
                        CourseRow( // custom row show course info
                            course: course,
                            gotEnga: enrollmentStatus[course.id ?? UUID()] ?? student.arrCou.contains(course), // enrolled status of assigned and unassigned
                            actionTs: { togEnr(for: course) } // used toogle when clicked
                        )
                    }
                }
                .navigationTitle("Enroll in Courses") // add the nav title
                
                if let alert = alert { // show the alert message
                    Text(alert)
                        .font(.subheadline) // make it subheading
                        .foregroundColor(alert.contains("assigned") ? .green : .red) // add text as assigend and add color green and red
                        .padding() // set required padding
                        .transition(.opacity) // add the opacity as well
                        .animation(.easeInOut, value: alert) // add animation and alert system
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // auto hide the alert after 1 seconds
                                withAnimation {
                                    self.alert = nil // show animation and go back
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            // Initialize enrollment status  when teh view show
            if enrollmentStatus.isEmpty {
                initializeEnrollmentStatus() // status of enrolled
            }
        }
    }
    
    private func togEnr(for course: Course) { // make function to toogle enrolled of course
        let engedr = enrollmentStatus[course.id ?? UUID()] ?? student.arrCou.contains(course) // getting the latest status
        
        // Toggle the enrollment status system
        if engedr {
            student.delCour(course, context: viewContext) // unassigend course to studnets
            alert = "Course \(course.name ?? "Unknown") unassigned" // alert for unassigned
            enrollmentStatus[course.id ?? UUID()] = false  // Update status to unassigned side
        } else {
            student.addSafe(course, context: viewContext) // assigend course to students
            alert = "Course \(course.name ?? "Unknown") assigned!" // alert course to assigend studnets
            enrollmentStatus[course.id ?? UUID()] = true  // modify status to "assigned"
        }
        
        do {
            try viewContext.save() // saving the modification to database
          
            student.objectWillChange.send()   // Notify UI of changes
        } catch {
            print("Failed to save context: \(error.localizedDescription)") // show this message if fails to save
            alert = "Failed to update enrollment" // show this alert if failed to modify
        }
    }
    
    private func initializeEnrollmentStatus() {// function to inilize enrollement status from database

        for course in eveyCo {        // Ensure enrollmentStatus reflects the actual status in the database
            // Check if the course is currently assigned to the student in Core Data
            let gotEnga = student.arrCou.contains(course)
            enrollmentStatus[course.id ?? UUID()] = gotEnga // message of enrolled status 
        }
    }
}

struct CourseRow: View { // custom row to show each course with assigend and unassigend butotn
    let course: Course // course to show
    let gotEnga: Bool // make sure if the students is enrolled or not
    let actionTs: () -> Void // action whe button is clicked
    
    var body: some View { // main body view page
        HStack {
            VStack(alignment: .leading) { // alignment leading
                Text(course.name ?? "Unknown Course") // text name as unknown
                    .font(.headline) // add it to headline
                Text(course.code ?? "") // for course code
                    .font(.subheadline) // make this subhead
                    .foregroundColor(.gray) // fill color as gray
            }
            Spacer() // bring elements on top
            
            Button(action: actionTs) { // assigen and unassigend button
                Text(gotEnga ? "Assigned" : "Unassigned") // add the option of assigend and unassigend
                    .foregroundColor(.white) // add white color
                    .padding(.horizontal, 11) // add padding in right side
                    .padding(.vertical, 7) // vertical side padding
                    .background(gotEnga ? Color.green : Color.red) // BG color as red and green
                    .cornerRadius(9) // make the border radius
            }
            .buttonStyle(PlainButtonStyle()) // delete the default button style
        }
        .padding(.vertical, 9) // paddiong for row spacing
        .contentShape(Rectangle()) // make the all row tapped 
    }
}
