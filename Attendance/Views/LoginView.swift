import SwiftUI // Importing the swift UI for buildling

struct LoginView: View { // main login view for admin or student
    @EnvironmentObject var authVM: AuthViewModel // getting access to authenmtication view mode
    @Environment(\.presentationMode) var presentationMode // for dismissal the view
    let isAdmin: Bool // determine if this is admin or student
    
    @State private var email = "" // input state variable for email
    @State private var password = "" // input state var for password
    @State private var alertMess = false // alert state varibale
    @State private var showeMes = "" // state variable for show message
    @State private var pasDis = false // toogle password visiblity
    @State private var processing = false // loading indicator state
    
    // Combination of  color scheme
    private var primColor: Color {
        isAdmin ? Color(red: 0.57, green: 0.46, blue: 0.95) : Color(red: 0.31, green: 0.74, blue: 0.61) // multiple colors
    }
    
    private var bgCo: LinearGradient { // add BG graident based on User
        LinearGradient( // link linear gradient
            gradient: Gradient(colors: [
                Color(red: 0.06, green: 0.14, blue: 0.32), // color combination
                isAdmin ? Color(red: 0.15, green: 0.34, blue: 0.69) : Color(red: 0.19, green: 0.61, blue: 0.49) // multiple colors link
            ]),
            startPoint: .topLeading, // add start point
            endPoint: .bottomTrailing // add end point trailing
        )
    }
    
    var body: some View { // main view boyd page
        NavigationView { // add nav bar
            ZStack {
                bgCo // making full gardient BG
                    .edgesIgnoringSafeArea(.all) // ignore the safest area
                
                VStack(spacing: 31) { // add vertical spacing
                    //  Mian Header Section
                    VStack(spacing: 21) { // again vertical stack with spacing
                        if #available(iOS 15.0, *) { // verify if this runs in ios 12
                            Image(systemName: isAdmin ? "key.fill" : "graduationcap.fill") // add tyhe logo and icon for admin
                                .font(.system(size: 61, weight: .thin)) // make it thin and size
                                .symbolRenderingMode(.hierarchical) // make font as herrichal
                                .foregroundColor(primColor) // add the primary color
                        } else {
                            // it wil go back to earlier versions
                        }
                        
                        VStack(spacing: 9) { // vertical spacing declare as 9
                            Text(isAdmin ? "Admin Portal" : "Student Portal") // title for student or admin
                                .font(.system(size: 27, weight: .bold, design: .rounded)) // combination of font like bold and design
                                .foregroundColor(.white) // text as white color
                            
                            Text(" University of GraceTech") // show this message on top
                                .font(.subheadline) // add font for the text
                                .foregroundColor(.white.opacity(0.8)) // color as white and opactiy
                        }
                    }
                    .padding(.top, 41) // add top side padding as 41
                    
                    // Form input sections
                    VStack(spacing: 23) { // V spacing
                        // Email input section
                        HStack {
                            Image(systemName: "envelope.fill") // add the icon that is suit
                                .foregroundColor(.white.opacity(0.7)) // add color and opacity
                            TextField("University Email", text: $email) // add the uni email
                                .keyboardType(.emailAddress)// keyboard type for email address
                                .autocapitalization(.none) //make it auto capitalization model
                                .disableAutocorrection(true) // make true the auto correction
                                .foregroundColor(.white) // text color as white
                        }
                        .textFieldStyle(styleTx(primColor: primColor))
                        
                        // Password input with toogle
                        HStack {
                            Image(systemName: "lock.fill") // add suitable icon of lock
                                .foregroundColor(.white.opacity(0.7)) // add color with opacity
                            
                            if pasDis {
                                TextField("Password", text: $password) // input field for the password part
                                    .foregroundColor(.white) // make it in white color
                            } else {
                                SecureField("Password", text: $password) // securing the password field
                                    .foregroundColor(.white) // make this also in white color
                            }
                            
                            Button { // toogle for password visiblity
                                pasDis.toggle() // add tootle feature
                            } label: {
                                Image(systemName: pasDis ? "eye.slash.fill" : "eye.fill") // add the required icon
                                    .foregroundColor(.white.opacity(0.7)) // link color as white and opacity 7
                            }
                        }
                        .textFieldStyle(styleTx(primColor: primColor)) // add color combination
                        
                        // Login Button with indicator
                        Button(action: login) {
                            if processing { // process to login
                                ProgressView() // progess view begins here
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white)) // make the tint in white color
                            } else {
                                Text("Login") // to login text
                                    .font(.headline) // headline of login
                                    .frame(maxWidth: .infinity) // make it fit in frame
                            }
                        }
                        .buttonStyle(styleButt(primColor: primColor, processing: processing)) // adding the multiple color of button and stylish
                        .padding(.top, 17) // top side padding 
                    }
                    .padding(.horizontal, 31) // add the padding in horizontal side
                    
                    if !isAdmin { // info for the studnts
                        Text("Contact admin for credential recovery") // text to see tyhe students when they foget the password
                            .font(.caption) // make the font caption
//                            .foregroundColor(.white.opacity(0.7)) / make color as white
                            .transition(.opacity) // linked opacity
                    }
                    
                    Spacer() // bringing teh elemenets to top side
                }
            }
            .navigationBarTitleDisplayMode(.inline) // inline nav items
            .navigationBarItems( // buttons for the nav bar
                leading: Button(action: dismiss) { // button for the dismissal
                    HStack { // add stack in H side
                        Image(systemName: "chevron.left") // icon of chevron
                            .font(.system(size: 16, weight: .bold)) // make the icon bold and weight
                        Text("Back") // add back option
                    }
                    .foregroundColor(primColor) // addthe required color
                },
                trailing: Button("Close") { dismiss() } // add the close  button to stop the operation
                    .foregroundColor(primColor) // add the necessay color fo this
            )
            .alert(isPresented: $alertMess) { // alert for login error
                Alert(
                    title: Text("Login Failed").foregroundColor(primColor), // login error message and color
                    message: Text(showeMes), // dispaly the message here
                    dismissButton: .default(Text("OK")) // add default text as OK
                )
            }
        }
    }
    
    private func login() { // function to process login
        processing = true // display the spinner
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            defer { processing = false } // make stop the spinner
            
            if isAdmin { // hardcoded admin credentiasl
                if email == "admin12@gmail.com" && password == "admin123" { // declaring the admin email and password
                    authVM.logging(email: email, password: password) // calling the authenticaiton view model
                    dismiss() // stop the login screen
                } else {
                    showeMes = "Invalid admin credentials" // show the error credentailas
                    alertMess = true // show the alert message
                }
            } else {
                authVM.logging(email: email, password: password) // again calling the authenticaiton view model
                if authVM.authoriZed {
                    dismiss() // dismissal option
                } else {
                    showeMes = "Invalid student credentials" // if the studnets data not macthed then show this message
                    alertMess = true // display the message
                }
            }
        }
    }
    
    private func dismiss() { // function for dismissal
        presentationMode.wrappedValue.dismiss() // dismissal logic and wrapped value 
    }
}
struct styleTx: TextFieldStyle { // text field style for the UI
    var primColor: Color // inilize the primary color
    
    func _body(configuration: TextField<Self._Label>) -> some View { // main view body configuration
        configuration
            .padding(12) // add the required padding
            .background(
                RoundedRectangle(cornerRadius: 11) // add the border radius
                    .fill(Color.white.opacity(0.16)) // filling the color and opacity
            )
            .overlay( // overlay logic
                RoundedRectangle(cornerRadius: 11) // make the rounded corner as well
                    .stroke(primColor.opacity(0.6), lineWidth: 1) // link the primary opacity and line width
            )
    }
}
struct styleButt: ButtonStyle { // linking the custom styyle button
    var primColor: Color // add primary color
    var processing: Bool // filling the bool processing
    
    func makeBody(configuration: Configuration) -> some View { // making the main body view configuration
        configuration.label
            .foregroundColor(.white) // add text color as white
            .padding(.vertical, 14) // add best vertical side padding
            .background( // BG part
                RoundedRectangle(cornerRadius: 10) // make the corner radius
                    .fill(primColor) // filing the primaryu color in required field
                    .shadow(color: primColor.opacity(0.3), radius: 11, x: 0, y: 4) // adding the shadow and opacity
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1) // filling the scale effect as well
            .opacity(processing ? 0.7 : 1) // link opacity processing 
    }
}
