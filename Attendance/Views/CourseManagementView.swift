import SwiftUI // importing the swift UI for building
import CoreData // Manage

struct rowIf: View { // reusable row view
    let icon: String // symbol and icon name
    let label: String // add labell text
    let value: String // value string
    
    var body: some View { // main body view
        HStack(spacing: 12) { // add the horizontal side spacing
            Image(systemName: icon) // show the icon as well
                .foregroundColor(.purple) // add teh pruple color
                .frame(width: 24) // adding teh frame width
            
            VStack(alignment: .leading) {
                Text(label) // text as lable
                    .font(.subheadline) // font as subheading -
                    .foregroundColor(.secondary) // add secondary text color
                Text(value) // real value
                    .font(.body) // font in body
            }
        }
        .padding(.vertical, 4) // vertical side padding
    }
}
struct CourseManagementView: View { // major course manage view
    @Environment(\.managedObjectContext) private var viewContext // context of the core datae
    @FetchRequest( // fetching the course from database
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default // default animation and ascending order
    ) private var courses: FetchedResults<Course> // fetch result from database
    
    @State private var txtSeac = "" // state for he search text
    @State private var dispAdcou = false // state to display the add course sheet
    
    var courPic: [Course] { // filtering the course as per seach
        if txtSeac.isEmpty { // if the course is nil
            return Array(courses) // returns course
        } else {
            return courses.filter { course in // filtering the added course
                (course.name?.lowercased().contains(txtSeac.lowercased()) ?? false) || // course name in lower case
                (course.code?.lowercased().contains(txtSeac.lowercased()) ?? false) // course code and make it in lower case
            }
        }
    }

    var body: some View { // main body view page
        NavigationView { // nav section
            VStack { // vertical stack side
                //section fopr  Search Bar
            TextField("Search courses....", text: $txtSeac) // text to seach the courses
                    .padding(11) // padding for seeach
                    .background(Color(.systemGray6)) // add system color in search
                    .cornerRadius(11) // make the border raedius in search
                    .padding(.horizontal) // add required padding in right side

                // nshow the  List of Courses
                List {
                    ForEach(courPic, id: \.self) { course in // using the for each loop
                        NavigationLink(destination: detailsCour(course: course)) { // add the nav link of teh destination
                            Cast(course: course) // custom view to show the course details
                        }
                        .contextMenu { // context menu begins
                            if #available(iOS 15.0, *) {// check to runs in ios
                                Button(role: .destructive) {
                                    removCo(course) // button to remove course
                                } label: {
                                    Label("Delete Course", systemImage: "trash") // add the icon of trash
                                }
                            } else {
                                // go back to earlist version
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle()) // make in ios group list
            }
            .navigationTitle(" Course Mangement") // title of teh top bar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // using tool bar and polacement
                    Button(action: { // button to show and add course
                        dispAdcou = true // display the add course
                    }) {
                        Label("Add", systemImage: "plus") // icon to add the course
                    }
                }
            }
            .sheet(isPresented: $dispAdcou) {  // when the course is presented
                manageCours()
                    .environment(\.managedObjectContext, viewContext) // manage to view context
            }
        }
    }

    private func removCo(_ course: Course) { // function to remove the course
        withAnimation {
            viewContext.delete(course) // added the adnmimation
            try? viewContext.save() // refresh and save
        }
    }
}
struct Cast: View { // Custom UI to show the course info
    let course: Course
    
    var body: some View { // main body view page
        HStack(spacing: 14) { // horizontal spacing with H stack
            Image(systemName: "book.closed") // add the icon of book
                .foregroundColor(.purple) // make it in purple color
                .font(.system(size: 28)) // font size as 28
                .padding(.trailing, 4) // add padding of 4
            
            VStack(alignment: .leading) { // add vertical alignment
                Text(course.name ?? "Unknown") // course name as unknown
                    .font(.headline) // add headline font
                Text(course.code ?? "Code") // add the course code
                    .font(.subheadline) // adding subheding to code
                    .foregroundColor(.gray) // make in gray color
                Text(course.schedule ?? "No schedule") // No shecdule message
                    .font(.caption) // make it caption
                    .foregroundColor(.secondary)// add the secondary
            }
        }
        .padding(.vertical, 7) // adding the vertical side padding
    }
}
struct manageCours: View { // add or edit the course hjere
    @Environment(\.managedObjectContext) private var viewContext // core data context
    @Environment(\.presentationMode) var presentationMode // for dismisal panel

    @State private var name: String // input for course name
    @State private var code: String // course code input
    @State private var schedule: String // shedule input
    @State private var alDisp = false // Alert message visiblity
    @State private var dispMes = "" // message for alert
    
    var course: Course? // when modification the course to edit

    init(course: Course? = nil) { // initlizer to link fields if editing
        _name = State(initialValue: course?.name ?? "") // state variable for the name
        _code = State(initialValue: course?.code ?? "") // state varibale for the code
        _schedule = State(initialValue: course?.schedule ?? "") // state varibale for the shedule
        self.course = course // course management
    }

    var body: some View { // main view body page
        NavigationView { // add nav view here
            Form {
                Section(header: Text("Course Details")) { // input fields for course info
                    TextField("Course Name", text: $name) // input for course name
                    TextField("Course Code", text: $code) // course code input
                    TextField("Schedule", text: $schedule) // shedule for course
                }

                Section { // section to save action
                    Button(action: courSav) { // button to save action
                        Text("Save Course") // save course messgae here
                            .frame(maxWidth: .infinity) // make fit in frame
                    }
                    .disabled(name.isEmpty || code.isEmpty) // if the course name is nil then nil the code
                }
            }
            .navigationTitle(course == nil ? "Add Course" : "Edit Course") // adding the title for add and update course
            .toolbar { // using toolbar
                ToolbarItem(placement: .navigationBarLeading) { // adding the tool bar placement font
                    Button("Cancel") { // add cancel button
                        presentationMode.wrappedValue.dismiss() // cancel or dismissal of presentation mode
                    }
                }
            }
            .alert(isPresented: $alDisp) { // for alert message
                Alert(title: Text("Error"), message: Text(dispMes), dismissButton: .default(Text("OK"))) // alert text and button for alert
            }
        }
    }

    private func courSav() { // function to save course data into database
        let rate = course ?? Course(context: viewContext) // using the existing course
        rate.name = name // fix name of course
        rate.code = code // fix code of course
        rate.schedule = schedule // set course shedule
        if course == nil {
            rate.id = UUID() // assiging the id for new course
        }
        
        do {
            try viewContext.save() // try to save changes to database
            presentationMode.wrappedValue.dismiss() // dismissal the view on sucessful
        } catch {
            dispMes = "Failed to save course: \(error.localizedDescription)" // show this message if fails to save
            alDisp = true // show the alert
        }
    }
}

struct detailsCour: View { // course details view begins here
    @ObservedObject var course: Course // observed course object
    @Environment(\.managedObjectContext) private var viewContext // context for the core data
    @Environment(\.presentationMode) var presentationMode // in order to dimiss the view
    
    @State private var students: [Student] = [] // listed of added students
    @State private var modiCour = false // dispaly modify sheet flag
    @State private var remoSure = false // remove confirm alert flag

    var body: some View { // main body view page
        Form {
            // section to display the course info
            Section(header: Text("Course Info")) { // message to show the course info
                rowIf(icon: "book", label: "Name", value: course.name ?? "Unknown") // add icon and name
                rowIf(icon: "number", label: "Code", value: course.code ?? "No Code") // add icon and course code
                rowIf(icon: "calendar", label: "Schedule", value: course.schedule ?? "N/A") // add teh shedule time of course
            }

            Section(header: Text("Students Enrolled")) { // this part is for show the student enrolled
                if students.isEmpty {
                    Text("No students enrolled") // show if the students are not present
                        .foregroundColor(.gray) // add the gray color
                } else {
                    ForEach(students, id: \.self) { student in // studnet list and using loop thorugh
                        HStack(spacing: 11) { // horizontal satck spacing as 11
                            Image(systemName: "person.crop.circle.fill") // add icon for student
                                .foregroundColor(.blue) // set bule as color
                                .font(.title3) // add title for this

                            VStack(alignment: .leading) { // set vertical alignment
                                Text(student.name ?? "Unknown") // add name of students
                                    .font(.body) // make it body
                                Text(student.email ?? "No email") // email of the students
                                    .font(.caption) // making caption
                                    .foregroundColor(.secondary) // add secondary color
                            }
                        }
                        .padding(.vertical, 5) // add vertical padding as 5
                    }
                }
            }
        }
        .navigationTitle("Course Detail") // title for the navigation
        .navigationBarTitleDisplayMode(.inline) // show bth inline title
        .toolbar { // using toolbar
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { // button for modify
                    modiCour = true
                } label: {
                    Image(systemName: "square.and.pencil") // add the pencil icon for edit
                }
                .sheet(isPresented: $modiCour) { // when the sheet is ok
                    manageCours(course: course) // open teh edit ot course
                        .environment(\.managedObjectContext, viewContext) // bypass the core data context
                }

                Button { // button for remove
                    remoSure = true // dispaly teh remove confirmation
                } label: {
                    Image(systemName: "trash") // icon for  remove
                        .foregroundColor(.red) // make it in red color
                }
            }
        }
        .alert(isPresented: $remoSure) { // alert confirmation for delete
            Alert(
                title: Text("Delete Course"), // text for delete
                message: Text("Are you sure you want to delete this course?"), // asking for ensure to delete
                primaryButton: .destructive(Text("Delete")) { // text delete added
                    removCo() // operate the delete
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            getStu() // feteching the students view appears
        }
    }

    private func getStu() { // function to enrolled students to this course
        let request: NSFetchRequest<Student> = Student.fetchRequest() // making the fetch request
        request.predicate = NSPredicate(format: "ANY courses == %@", course) // filtering by the course details
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Student.name, ascending: true)] // sorting in ascendiong order
        
        do {
            students = try viewContext.fetch(request) // update try fetch students
        } catch {
            print("Failed to fetch students: \(error.localizedDescription)") // show error if fails to fetch
        }
    }

    private func removCo() { // function to delete the course
        withAnimation { // add some animation
            viewContext.delete(course) // remove from context
            try? viewContext.save() // refresh and saving the deletion
            presentationMode.wrappedValue.dismiss() // make dismiss the view 
        }
    }
}
