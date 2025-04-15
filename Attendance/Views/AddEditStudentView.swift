import SwiftUI // importing the switf UI for building UI
import CoreData // Import core data for management of database

@available(iOS 15, *) // verify the code runs in ios 15 or not
struct AddEditStudentView: View { // main view for the update and edit the students
    @Environment(\.managedObjectContext) private var viewContext // accessing the core data from database
    @Environment(\.presentationMode) var presentationMode // update to dismiss the view
    
    @State private var name = "" // state variable for name input
    @State private var email = "" // state varibale for email input
    @State private var password = "" // satte variable for password section
    @State private var alerDiss = false // state for alert show
    @State private var msgDis = "" // state for alert message dispaly
    @State private var shoeSucc = false // to show success alert
    
    var student: Student? // existing students object
    var onSave: (() -> Void)? = nil  // optional callback function to clicked parent refresh after saved
    
    var body: some View { // main body view page
        NavigationView { // Nav bview
            Form {
                Section(header: Text("Student Information")) { // section to input student info
                    TextField("Full Name", text: $name) // input for full name
                        .padding() // add padding for name
                        .background(RoundedRectangle(cornerRadius:  10).strokeBorder(Color.gray, lineWidth: 1)) // make the BG color and gray color as inline width
                        .padding(.bottom, 11) // bottom side padding
                    
                    TextField("University Email", text: $email) // text for University email section
                        .keyboardType(.emailAddress) // add keyboard type fr email section
                        .autocapitalization(.none) // enalbe auto capital
                        .padding() // add necessary padding
                        .background(RoundedRectangle(cornerRadius: 1).strokeBorder(Color.gray, lineWidth: 1)) //adding the combination of font, color and inline
                        .padding(.bottom, 11) // padding in bottom side
                    
                    SecureField("Temporary Password", text: $password) // password input field
                        .padding() // set required padding
                        .background(RoundedRectangle(cornerRadius: 11).strokeBorder(Color.gray, lineWidth: 1)) // add combination of font like color inline and other
                        .padding(.bottom, 11) //ppadding in the bottom side
                }
                
                Section { // section to add an edit students
                    Button(student == nil ? "Add Student" : "Save Changes") { // option to add and save changes
                        savedS() // calling the save mechanism
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty) // disable the button if there any empty section
                    .padding()// add necessay padding
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                    .foregroundColor(.white) // combination of color, inline and make it rounded
                    .padding(.top) // add top side padding
                }
            }
            .navigationTitle(student == nil ? "New Student" : "Edit Student") // add the nav title as per add or edit mode
            .navigationBarTitleDisplayMode(.inline) // make the inline mode
            .toolbar { // cancel option in tool bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { // add the cancel option
                        presentationMode.wrappedValue.dismiss() // view the dismissial mode
                    }
                }
            }
            .alert(isPresented: $alerDiss) { // dispaly the alert if validation or saving files
                Alert( // alert logic
                    title: Text("Error"), // text for alert
                    message: Text(msgDis), // show messgae alert
                    dismissButton: .default(Text("OK")) // dismiss button as OK
                )
            }
            .alert(isPresented: $shoeSucc) { // show the alert after the dismissal
                Alert(
                    title: Text("Success"), // text as sucees
                    message: Text("Student \(student == nil ? "added" : "updated") successfully"), // show the text message as update anhd added
                    dismissButton: .default(Text("OK")) { // add the OK button
                        onSave?() // triggering after update
                        presentationMode.wrappedValue.dismiss() // dismissal view after view
                    }
                )
            }
            .onAppear { // pre filled if editing if editing anexising students
                if let student = student { // for student section
                    name = student.name ?? "" // name of the student s
                    email = student.email ?? "" // email of the student
                    password = student.password ?? "" // password of the studetns
                }
            }
        }
    }
    
    private func savedS() { // saved login logic
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else { // verify all the fields are not empty
            msgDis = "All fields are required" // show the message if not are required
            alerDiss = true // show the alert
            return // returing the message
        }
        
        guard rightEma(email) else { // checking if the email format are filled
            msgDis = "Please enter a valid university email" // show the valid uni email
            alerDiss = true // show the message
            return
        }
        
        let stosSa = student ?? Student(context: viewContext) // make the students or update existing
        if student == nil {
            stosSa.id = UUID() // assigning the uinque ID
        }
        stosSa.name = name //name input field
        stosSa.email = email // email input section
        stosSa.password = password // password input section
        
        do {
            try viewContext.save() //saving into the core data
            shoeSucc = true // show success message
        } catch {
            msgDis = "Operation failed: \(error.localizedDescription)" // if the logic fails then show this message
            alerDiss = true // alerting the true
        }
    }
    
    private func rightEma(_ email: String) -> Bool { // checking the function of email validation
        let hasedE = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // set tof string to store in core data 
        let conEma = NSPredicate(format:"SELF MATCHES %@", hasedE) // hahsed value to store
        return conEma.evaluate(with: email) // returning the anile validation
    }
}
