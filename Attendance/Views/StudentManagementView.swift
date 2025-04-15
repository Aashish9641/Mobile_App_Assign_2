import SwiftUI // importing the swift UI
import CoreData // import of the core data

@available(iOS 15.0, *) // verify if this is available for ios 15
struct StudentManagementView: View { // management of the students
    @EnvironmentObject var authVM: AuthViewModel // ibjecting the auth view model enviroment
    @Environment(\.managedObjectContext) private var viewContext // getting access to core database manage object context
    @Environment(\.dismiss) private var dismiss // using dismiss to latest view

    @FetchRequest( // fetching all the added students
        sortDescriptors: [NSSortDescriptor(keyPath: \Student.name, ascending: true)],
        animation: .default // animation as default and ascending order
    ) private var students: FetchedResults<Student> // result of fetched students

    @State private var txtSer = "" // state varibale to store seach
    @State private var addStu = false // state to add studnet sheet
    @State private var studEdi: Student? // state to edit student sheet
    @State private var removAle = false // state to delete alert
    @State private var dtutoRe: Student? // holding the students to be removed
    @State private var doRef = UUID() // do refresh when needed

    var filStu: [Student] { // filtering the studnet as per search
        guard !txtSer.isEmpty else { return Array(students) } // returning the arrary
        return students.filter {
            $0.name?.lowercased().contains(txtSer.lowercased()) ?? false || // filtering the lowercase
            $0.email?.lowercased().contains(txtSer.lowercased()) ?? false // that contains fails and when lowercase
        }
    }

    var body: some View { // main body view pages
        NavigationView { // nav bar link
            VStack { // stack for the vertical side
                if students.isEmpty { // if there is no student
                    Spacer() // bring to top elements
                    Text("No Students Found") // message show if there is no students
                        .font(.title3) // set as title 3
                        .foregroundColor(.gray) // add the color greay
                    Spacer() // adding spacer as well
                } else {
                    ScrollView { // add scroll view propeties
                        LazyVStack(spacing: 9) { // add lazy spaceing as 9
                            ForEach(filStu, id: \.self) { student in // loop thorugh filter the students
                                caseSt(for: student)
                            }
                        }
                        .padding(.top) // set top side padding
                    }
                    .searchable(text: $txtSer) // adding the search bar section
                    .id(doRef) // do refresh
                }
            }
            .padding() // add suitabe padding
            .navigationTitle("🎓 Student Management") // nav title heading
            .navigationBarTitleDisplayMode(.inline) // makeing the inline heading
            .navigationBarItems(leading: Button(action: {
                dismiss() // dismissial button action
            }) {
                HStack {
                    Image(systemName: "chevron.left") // adding the icon
                    Text("Back") // add back option here
                }
                .foregroundColor(.blue) // set color as blue
            })
            .toolbar { // tool bar with add students button
                ToolbarItem(placement: .navigationBarTrailing) { // making the tool var traling
                    Button(action: { addStu = true }) { // button aciton top add students
                        Label("Add Student", systemImage: "plus.circle.fill") // add the plus icon for add
                            .foregroundColor(.blue) // add blue color
                            .font(.title2) // make it in title 2
                    }
                }
            }
            .sheet(isPresented: $addStu) { // sheet to add new student
                AddEditStudentView(onSave: refreshList) // do refresh auto
                    .environment(\.managedObjectContext, viewContext) // enviroment view context
            }
            .sheet(item: $studEdi) { student in // shett to modify the students
                AddEditStudentView(student: student, onSave: refreshList) // do refresh the modified list
                    .environment(\.managedObjectContext, viewContext) // enviromental view context
            }
            .alert(isPresented: $removAle) { // confirmation of alerting before remove
                Alert(
                    title: Text("Delete Student"), // text to remove students
                    message: Text("Are you sure you want to delete \(dtutoRe?.name ?? "this student")?"), // confimration messge to remove from list
                    primaryButton: .destructive(Text("Delete"), action: confirmDelete),// add the delete option to remove
                    secondaryButton: .cancel() // add the canel option
                )
            }
        }
        .navigationViewStyle(.stack) // make in Fullscreen on iPhone/iPad
    }

    private func caseSt(for student: Student) -> some View { // renders for each studnets card
        VStack { //vertical stack align
            HStack(spacing: 16) { // add 16 as right side spaceing
                Image(systemName: "person.crop.circle.fill") // add the required icon
                    .resizable() // make the icon resizeable
                    .frame(width: 50, height: 50) // make the width 50 and 50
                    .foregroundColor(.blue) // add color as blue

                VStack(alignment: .leading, spacing: 6) { // add vfertical alignment
                    Text(student.name ?? "Unknown Student") // name of the students here
                        .font(.headline) // headline font
                    Text(student.email ?? "No email") // add the email of the students
                        .font(.subheadline) // make also this subheading
                        .foregroundColor(.gray) // make this color as gray
                }

                Spacer() // bring all elements to top side

                NavigationLink(destination: CourseEnrollmentView(student: student)) { // show the enrolled course to enrollement view
                    VStack(spacing: 2) { // vertical side alignment
                        Text("\(student.courses?.count ?? 0)") // text count with courses
                            .font(.headline) // font heading added
                            .foregroundColor(.purple) // link the pruple color
                        Text("Courses") // add text as courses
                            .font(.caption) // make caption
                            .foregroundColor(.gray) // add the gray color
                    }
                }
                .buttonStyle(PlainButtonStyle()) // make the bbutton as plain style

                HStack(spacing: 12) { // add horizontal side spacing
                    Button(action: { editStudent(student) }) { // button action for remove
                        Image(systemName: "square.and.pencil") // added the edit icon
                            .foregroundColor(.orange) // make this in orange color
                            .imageScale(.large) // add scale as large
                    }

                    Button(action: { confirmDelete(student) }) { // button action for confirm remove
                        Image(systemName: "trash.fill") // add the icon for trash
                            .foregroundColor(.red) // add red color
                            .imageScale(.large) // make this large
                    }
                }
                .buttonStyle(BorderlessButtonStyle()) // protect UI glitch in buttons
            }
            .padding() // add required padding
            .background(Color(.systemGray6)) // Set BG color as gray
            .cornerRadius(12) // make the border radius
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2) // color combination for shadow
            .padding(.horizontal) // right side padding set
        }
    }

    private func editStudent(_ student: Student) { // opens edit panel with choosen studnets
        studEdi = student
    }

    private func confirmDelete(_ student: Student) { // opens remove confimration
        dtutoRe = student
        removAle = true // remove true here
    }

    private func confirmDelete() { // remove students from database and save
        guard let student = dtutoRe else { return }

        withAnimation { // add animation
            viewContext.delete(student)
            do {
                try viewContext.save() // saving after remove
                refreshList() // do redresh auto
            } catch {
                print("Error deleting student: \(error.localizedDescription)") // message if there is error in delete
            }
        }
    }

    private func refreshList() { // view refresh by updating UUID
        doRef = UUID() // do refresh here
    }
}
