import SwiftUI // importing teh swift UI for better Framework
import CoreData // Management of the database

@available(iOS 15.0, *) // make sure to run in ios 15
struct StudentProfileView: View { // make teh custom view for student profile
    @EnvironmentObject var authVM: AuthViewModel // its is used to get the latest info of student
    @Environment(\.managedObjectContext) private var viewContext // setting the context of coredata
    
    // added the state variables of UI updates
    @State private var newPassword = "" // input for new password
    @State private var passSure = "" // input for conform the password
    @State private var altSho = false // input for alert show
    @State private var altMsg = "" // content for message alerting
    @State private var modifyD = false // added toogle profile edit mode
    @State private var namMod = "" // modify teh name input
    
    var student: Student? { // update elements to get the currrrent student from authentication
        authVM.studeRight // same logic applied
    }
    
    var body: some View { // added body for view part
        ScrollView { // added screoll view part
            VStack(spacing: 20) { // added vertical spacing of 20
                // profile header
                VStack(spacing: 15) { // added the spacing in vertical side
                    Image(systemName: "person.crop.circle.fill") // set the icon
                        .resizable() // add resizeable featrures
                        .scaledToFit() // added the font of fit as per the scale
                        .frame(width: 100, height: 100) // declare the width and height
                        .foregroundColor(.blue) // color as blue
                    
                    if modifyD { // display either a text part for editing or not
                        TextField("Name", text: $namMod) // make it edit the name
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // make teh stylish field
                            .multilineTextAlignment(.center) // place them in center
                            .font(.title) // font size for text
                    } else {
                        Text(student?.name ?? "Student Name") // show the student name
                            .font(.title) // add the title for the font
                            .fontWeight(.bold) // make bold the text
                    }
                    
                    Text(student?.email ?? "student123@gmail.com") // show the default emaail
                        .font(.subheadline) // make small font
                        .foregroundColor(.gray) // add gray color
                }
                .padding(.top, 30) // top side padding
                
                // Edit the profile  Button
                Button {
                    if modifyD {
                        changePrf() // saving teh modification in database
                    } else {
                        namMod = student?.name ?? "" // name fields is prefilled
                        modifyD = true // allow the editing mode
                    }
                } label: {
                    // changing the label based on the mode
                    Label(modifyD ? "Save Changes" : "Edit Profile", systemImage: modifyD ? "checkmark" : "pencil") // text for save changes and modification of profile
                        .frame(maxWidth: .infinity) // make it in full width
                }
                .buttonStyle(PlainButtonStyle()) // set basic the style of thge button
                .padding() // add padding for the button
                .background(Color.blue) // blue color for the button
                .foregroundColor(.white) // text as in white color
                .cornerRadius(11) // add corner radius
                .padding(.horizontal) // added the padding in H side
                
                // Password Update part
                VStack(alignment: .leading, spacing: 14) { // add Vertical stack and spacking
                    Text("Change Password") // text for manipulcation of password
                        .font(.headline) // make the title in bold
                    
                    SecureField("New Password", text: $newPassword) // input field of new password
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // making stylish as rounded
                        .textContentType(.newPassword) // recommended the new password area
                    
                    SecureField("Confirm your Password", text: $passSure) // input field for confirm password
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // make it in stylish password
                        .textContentType(.newPassword) // suggesting the password field
                    
                    Button(action: pasUPs) { // declare button to update password
                        Label("Update your Password", systemImage: "key.fill")// added the button label and text
                            .frame(maxWidth: .infinity) // recommended the password part
                    }
                    .buttonStyle(PlainButtonStyle()) // basic button part
                    .padding() // add padding for the button
                    .background(Color.green) // make the green background
                    .foregroundColor(.black ) // text color as white
                    .cornerRadius(11) // add corner radius as 11
                    .disabled(newPassword.isEmpty || passSure.isEmpty) // not allow if this is empty
                }
                .padding() // set padding in inside part
                .background(Color(.secondarySystemBackground))// set light gray BG
                .cornerRadius(12) // added the radius corner
                .padding(.horizontal) // padding in horizontal side
                
                Spacer() // bring content to top side
            }
            .padding(.bottom, 21) // scorling bottom padding
        }
        .navigationTitle("My Profile") // set title for nav bar
        .alert(isPresented: $altSho) { // dispaly the alert when clicked
            Alert(title: Text("Profile Update"), message: Text(altMsg), dismissButton: .default(Text("OK"))) // save changes and profile update parties
        }
    }
    
    private func changePrf() { // function to change and save teh profile name
        guard let student = student else { return } // make sure the name is valid
        
        student.name = namMod // modify the name
        modifyD = false // existing from update mode
        
        do {
            try viewContext.save() // saving into the database
            altMsg = "Profile updated successfully" // show the success messgae
            altSho = true // dispaly the alert as well
        } catch {
            altMsg = "Failed to update profile: \(error.localizedDescription)" // if failed show this error message
            altSho = true // show the alert message
        }
    }
    
    private func pasUPs() { // this function is for modify the password
        guard !newPassword.isEmpty else { return } // make sure the password is not nil
        guard newPassword == passSure else { // verify the password is matched
            altMsg = "Passwords don't match" // if the password is mismatced show this mesage
            altSho = true // show this alert
            return // returns the part
        }
        
        guard let student = student else { return } // maksure the students exists
        
        student.password = newPassword // saving the new password
        newPassword = "" // make it clear the field
        passSure = "" // clearing the fields
        
        do {
            try viewContext.save() // saving into teh core data
            altMsg = "Password updated successfully" // suceess message
            altSho = true // show the alert
        } catch {
            altMsg = "Failed to modify your password:  \(error.localizedDescription)" // show this message if fails to update
            altSho = true // dispaly alert 
        }
    }
}
