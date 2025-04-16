import SwiftUI // Importing the swift for building UI
import CoreData // management of the database and import coredata

struct AttendanceView: View { // view controller as Attendance view
    @EnvironmentObject var authVM: AuthViewModel // getting access of shared authe view elements
    @Environment(\.managedObjectContext) private var viewContext // access of core data

    @FetchRequest( // code to fetch the course
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default) // add animation as default and sorted by name in ascending order
    private var courses: FetchedResults<Course> // consequences of fetch result

    @FetchRequest( // fetching the attendance records
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.date, ascending: false)], // sorting the date in ascending order
        animation: .default)
    private var lagaAtte: FetchedResults<Attendance> // consequences of fetch result

    @State private var datPick = Date() // holding the chosen date for attendance for mark
    @State private var confimDispl = false // controlling the confirmation alert
    @State private var courseDone: Course? // make store the choosen course
    @State private var listhist = false // control visibility for the attendance

    var body: some View { // main view for the page
        let today = Calendar.current.startOfDay(for: Date()) // getting the today data

        ScrollView { // scroll view added for better UI
            VStack(spacing: 20) { // added vertical stack
                // code to choose the today date only
                VStack(spacing: 10) { // add vertical space in vertical side
                    DatePicker("Select Date", selection: $datPick, in: today...today, displayedComponents: .date) // choosing the date of today
                        .datePickerStyle(.graphical) // make the stylish

                    Button(action: { listhist.toggle() }) { // add button to toggle attendance view
                        HStack {
                            Image(systemName: "clock.arrow.circlepath") // adding the image of button
                            Text(listhist ? "Hide Attendance History" : "Show Attendance History") // show the message to see the hide and show the histry of attendance
                        }
                        .font(.subheadline) // made subheading as font
                    }
                }
                .padding() // fix necessary padding
                .background(Color(.secondarySystemBackground)) // add system BG color
                .cornerRadius(12) // making the border radisu
                .padding(.horizontal) // set the padding in horizontal side

                //  code to see the Attendance History
                if listhist {
                    VStack(alignment: .leading) { // vertical side alighement
                        Text("Attendance History") // text to display
                            .font(.headline) // add heading
                            .padding(.bottom, 4) // set required padding in bottom side

                        if lagaAtte.isEmpty { // query if no data found here
                            Text("No attendance records yet") // message show if there is no any data
                                .foregroundColor(.gray) // make te color as gray
                                .padding() // add padding
                        } else {
                            ForEach(lagaAtte.prefix(5)) { attendance in
                                disprowAtt(attendance: attendance) // dispaly the top 5 attendance recorded
                            }

                            if lagaAtte.count > 5 { // when the records are more than 5 the show the nav link
                                NavigationLink(destination: allattVie()) { // set nav link to see
                                    Text("View All (\(lagaAtte.count))") // set message to see or view all
                                        .font(.subheadline) // sub heading added
                                        .foregroundColor(.blue) // add bkue as front color
                                }
                            }
                        }
                    }
                    .padding() // add padding
                    .background(Color(.secondarySystemBackground)) // set BG system color
                    .cornerRadius(12) // make border radius
                    .padding(.horizontal) // add padding in right side
                }

                // code will show the Courses List
                if courses.isEmpty {
                    viewNul // display the no courses view panel
                } else {
                    ForEach(courses) { course in // iterate through each and every couse and dispaly the attendance card
                        garAyye(
                            course: course, // added course
                            datPick: datPick, // to pick date add date picker
                            doneIs: attMaes(for: course, on: datPick), // verify if the attendance is already done or nor
                            attenMar: {
                                courseDone = course // verify the done process
                                confimDispl = true // show the confirmation message
                            },
                            latTod: Calendar.current.isDateInToday(datPick) // enable the today date attendace only
                        )
                    }
                }
            }
            .padding(.vertical) // set padding in vertical or top side
        }
        .navigationTitle("Attendance") // adding the title of the screen
        .alert(isPresented: $confimDispl) { // alert befor do attendance
            Alert(
                title: Text("Confirm Attendance"), // message for confirm attendance
                message: Text("Confirm you're marking attendance for \(courseDone?.name ?? "this course")"), // make sure to confirm the course of choosen course to attendance
                primaryButton: .default(Text("Mark Present")) { // add primary button and show mark present
                    if let course = courseDone { // code to corse done
                        markAttendance(for: course) // marking the attendance
                    }
                },
                secondaryButton: .cancel() // add the cancel option
            )
        }
    }

    private var viewNul: some View { // show if there is no courses
        VStack { // veritcal or top side stack
            Image(systemName: "book.closed.fill") // add the required icon
                .font(.system(size: 51)) // dont size
                .foregroundColor(.gray) // gary would be the color
                .padding() // add necessay padding

            Text("No courses enrolled") // display this message if there is no course
                .font(.headline) // add heading
                .foregroundColor(.gray) // link color as gray

            Text("Contact admin to enroll in courses") // if the course is not present then show the message to contact admin
                .font(.subheadline) // add subheading
                .foregroundColor(.gray) // color as gray
        }
        .padding(.top, 50) // set top side padding
    }

    private func attMaes(for course: Course, on date: Date) -> Bool { // show if the attendace exists for givgemn date and course
        lagaAtte.contains { attendance in // inning of the attendance
            attendance.course == course && // inning of the course
            Calendar.current.isDate(attendance.date ?? Date(), inSameDayAs: date)// code to show the same date and time as well
        }
    }

    private func markAttendance(for course: Course) { // function to mark the attendance
        let attendance = Attendance(context: viewContext) // view the course for mark attendance
        attendance.id = UUID() // added unique id for the attendance
        attendance.date = datPick // choose the date
        attendance.status = "Present" // make the status present
        attendance.student = authVM.studeRight // add latest students
        attendance.course = course // link the choosen course

        PersistenceController.shared.save() // saving the updated one to database
    }
}
struct garAyye: View { // course card for the course
    let course: Course // information for teh course
    let datPick: Date // picked date
    let doneIs: Bool // date done or not
    let attenMar: () -> Void // is attendance already done or not
    let latTod: Bool // // verify if the date is today

    var body: some View { // main side  for this page
        VStack(alignment: .leading, spacing: 10) { // veritcal alignment with spacing
            HStack { // linked horizontal spacing
                Image(systemName: "book.closed.fill") // linked required icon
                    .foregroundColor(.purple) // make the icon in pruple color

                VStack(alignment: .leading, spacing: 4) { // linked alignment with spacing
                    Text(course.name ?? "Unknown Course") // add the text to show as unknown
                        .font(.headline) // add headline

                    Text(course.schedule ?? "No schedule") // show this if there is no course
                        .font(.subheadline) // add subline heading
                        .foregroundColor(.gray) // add suit color
                }

                Spacer() // spacer to bring all elements
            }

            Divider() // adding the divider to components

            HStack { //linked to horizontal stack
                if #available(iOS 15.0, *) { // check if this runs or not in ios
                    Text(datPick.formatted(date: .abbreviated, time: .omitted)) // verify the formatted date
                        .font(.subheadline) // add the subheading as well
                }

                Spacer() // bringin the elements to top side

                Button(action: attenMar) { // button for mark attendance
                    HStack { // add horizontal stack
                        Image(systemName: doneIs ? "checkmark.circle.fill" : "checkmark") // link the chgeck mark icon
                        Text(doneIs ? "Attendance Marked" : "Mark Present") // show the messae as mark present if it is done
                    }
                    .padding(.horizontal) // add the padding in horizontal
                    .padding(.vertical, 7.5) // vertical side padding
                    .background(doneIs || !latTod ? Color.gray : Color.green) // added the required background color
                    .foregroundColor(.white) // added the foreground color
                    .cornerRadius(8) // making the border radius
                }
                .disabled(doneIs || !latTod) // disable of this is marked or not for today
            }
        }
        .padding() // link padding for the button
        .background(Color(.secondarySystemBackground)) // BG color as system
        .cornerRadius(12) // set border radiius
        .padding(.horizontal) // linked padding in right side
    }
}
struct disprowAtt: View { // structure to see the history of attendance
    let attendance: Attendance // single attendance record

    var body: some View { // main page for this panel
        HStack { // add horizontal stack
            VStack(alignment: .leading) { // link alignment in vertical
                Text(attendance.course?.name ?? "Unknown Course") // set course name as unknown
                    .font(.subheadline) // add font heading
                if #available(iOS 15.0, *) { // runs in ios 15
                    Text(attendance.date.formatted(date: .abbreviated, time: .omitted) ?? "No date") // if there is no date
                        .font(.caption) // add caption
                        .foregroundColor(.gray) // setting gray color
                }
            }

            Spacer() // adding the spacer

            Text(attendance.status ?? "Unknown") // show the message of status
                .foregroundColor(attendance.status == "Present" ? .green : .red) // add the messsage as present and add color as gray
                .padding(5) // adding padding
                .background(attendance.status == "Present" ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) // add color with opacity
                .cornerRadius(4) // make border
        }
        .padding(.vertical, 5) // link vertical side padding
    }
}
struct allattVie: View { // full attendance voew
    @Environment(\.managedObjectContext) private var viewContext // context for core data

    @FetchRequest( // fetching all attendance record
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendance.date, ascending: false)], // show the ascending record in asceding order
        animation: .default) // animation as default
    private var lagaAtte: FetchedResults<Attendance> // consequences of the fetching

    var body: some View { // mian var body view
        List {
            ForEach(lagaAtte) { attendance in // using each loop to show record
                disprowAtt(attendance: attendance) // show the attendace record
            }
        }
        .listStyle(.plain) // add plain style
        .navigationTitle("Attendance History")  // add the history message 
        .navigationBarTitleDisplayMode(.inline) // making inline display mode 
    }
}
