import SwiftUI // Importing the swift UI for better framework

struct ContentView: View { // main content view section
    @EnvironmentObject var authVM: AuthViewModel // Setting or inject auth view model to manage login partiers
    @State private var adminLog = false // state variable to control admin panel
    @State private var studeLogin = false // state variable to control student login
    @State private var animateElements = false // state variables to view animations
    
    // Custom  color palette combination
    let firsCol = Color(red: 0.08, green: 0.16, blue: 0.30) // adding the color of Deep navy blue
    let secoCol = Color(red: 0.3, green: 0.34, blue: 0.67) // using shade for secondary part
    let adminCOl = Color(red: 0.59, green: 0.45, blue: 0.94) // using the purple one for admin card
    let stuLopg = Color(red: 0.31, green: 0.74, blue: 0.61) // using or setting teal color for student
    
    var body: some View { // main view body page
        NavigationView { // embds view nav context
            ZStack {
                // Background gradient
                LinearGradient( // extra linear grident
                    gradient: Gradient(colors: [firsCol, secoCol]), // add linear graident for primary and secondary color
                    startPoint: .top, // begin the points
                    endPoint: .bottom // ending points at bottom
                )
                .edgesIgnoringSafeArea(.all) // making the full screen for graident part
                
                VStack(spacing: 31) { // add spacing in vertical side
                    // University header with subtle animation part here
                    VStack(spacing: 11) { // spacing and vertical side
                        if #available(iOS 15.0, *) { // verify whether this runs or not in IOS 15
                            Image(systemName: "building.columns.fill") // adding the required icon
                                .font(.system(size: 60, weight: .thin)) // add the font size
                                .symbolRenderingMode(.hierarchical) // making it in render mode
                                .foregroundColor(.white) // text color as white
                                .scaleEffect(animateElements ? 1 : 0.8) // setting the effect of animation
                                .opacity(animateElements ? 1 : 0) // fixing the opacity to this as well
                                .animation(.spring(response: 0.6, dampingFraction: 0.5), value: animateElements) // adding the effect to the animation part
                        } else {
                            Image(systemName: "building.columns.fill") // adding the required icon
                                .font(.system(size: 61, weight: .thin))// add the font size
                                .foregroundColor(.white)// add the font size
                                .scaleEffect(animateElements ? 1 : 0.8)// setting the effect of animation
                                .opacity(animateElements ? 1 : 0)// fixing the opacity to this as well
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animateElements) // adding the effect to the animation part
                        }
                        
                        Text(" University of GraceTech") // Declare the name of UNiversity to top
                            .font(.system(size: 27, weight: .bold, design: .rounded)) // make this rounded and bold
                            .foregroundColor(.white) // text color as white
                            .tracking(0.5) // tracking with 0.5
                            .opacity(animateElements ? 1 : 0) // adding the animation effect
                            .offset(y: animateElements ? 0 : 11) // in animation effect add offset feature
                            .animation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.1), value: animateElements) // adding the effect to the animation part
                        
                        Text("Attendance & Social System") // Subheading for the title
                            .font(.system(size: 15, weight: .medium, design: .rounded))// make this rounded and bold
                            .foregroundColor(.white.opacity(0.8)) // make the text color as white
                            .opacity(animateElements ? 1 : 0) // set the effect of animation
                            .offset(y: animateElements ? 0 : 11)// in animation effect add offset feature
                            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: animateElements)// adding the effect to the animation part

                    }
                    .padding(.top, 51) // top side padding declare
                    
                    Spacer() // add spacer to bring elements to top side of the screen
                    
                    // Using the Role selection cards with refined design
                    VStack(spacing: 21) { // veritcal stack with spacing
                        carOLe(
                            imgs: "key.fill", // add icon for admin
                            headMa: "Administrator", // header as admin
                            headSub: "Students & course Access", // decalear subheading for admin
                            color: adminCOl, // add the color suitable
                            action: { adminLog = true } // declare the login access to admin
                        )
                        .opacity(animateElements ? 1 : 0) // add animation effects
                        .offset(x: animateElements ? 0 : -31) // add offset feature to animation
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: animateElements) // adding the effect to the animation par
                        
                        carOLe( // for student part card
                            imgs: "graduationcap.fill", // add the required icon
                            headMa: "Student", // heading as student in student part
                            headSub: "Access to the University ", // Subheading
                            color: stuLopg, // add color combination for better UI
                            action: { studeLogin = true } // declaer the logic of login
                        )
                        .opacity(animateElements ? 1 : 0) // add animation effects
                        .offset(x: animateElements ? 0 : 30) // add offset feature to animation
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateElements)// adding the effect to the animation part
                    }
                    .padding(.horizontal, 31) // set padding in horizontal side
                    
                    Spacer() // bring components to top side
                    
                    // make the good footer side
                    Text("Version 5.12") // footer message in version
                        .font(.system(size: 11, weight: .medium)) // font size of the footer
                        .foregroundColor(.white.opacity(0.5)) // BG color for footer
                        .padding(.bottom, 25) // padding in bottom area
                        .opacity(animateElements ? 1 : 0) // add animation effects
                        .animation(.easeInOut(duration: 0.4).delay(0.7), value: animateElements) // adding the effect to the animation part
                }
            }
            .navigationBarHidden(true) // hidding the nav bar
            .sheet(isPresented: $adminLog) { // admin login panel sheet
                LoginView(isAdmin: true) // when the login true
                    .environmentObject(authVM) // after login true calls the auth view
            }
            .sheet(isPresented: $studeLogin) {  // student login panel
                LoginView(isAdmin: false) // when login false
                    .environmentObject(authVM) // calling the auth view model
            }
            .fullScreenCover(isPresented: $authVM.authoriZed) { // make the full screen after login
                if authVM.panelAdmi { // when login true for admin
                    AdminDashboardView() // redirect to admin dashbord view
                        .environmentObject(authVM) // also called auth view model with enviroment
                } else {
                    StudentDashboardView() // when studnet pass to login go to student dashboard
                        .environmentObject(authVM) // also called auth view model with enviroment
                }
            }
            .onAppear { // triggering the animation on appear
                animateElements = true // animation
            }
        }
        .accentColor(.white) // using the tint color for nav component
    }
}

struct carOLe: View { // Reuseable elements for role section
    let imgs: String // images name
    let headMa: String // main heading
    let headSub: String // sub heading
    let color: Color //color combination for each role
    let action: () -> Void // action while tap
    
    @State private var isPressed = false // when it is preseed it will be optional visual
     
    var body: some View { // main view body part
        Button(action: action) { // work with button action
            HStack(spacing: 16) { // add spacing in right side
                ZStack { // z stack operation
                    Circle()
                        .fill(color.opacity(0.2)) // add BG circle and tint light
                        .frame(width: 51, height: 49) // set frame width
                    
                    Image(systemName: imgs) // controlling images or icon
                        .font(.system(size: 21, weight: .bold)) // make the icon bold and fixed size
                        .foregroundColor(color) // add the color in icon
                }
                
                VStack(alignment: .leading, spacing: 3) { // add spacing in top side
                    Text(headMa) // text in main heading
                        .font(.system(size: 17, weight: .semibold, design: .rounded)) // make it bold and rounded the main heading
                        .foregroundColor(.white) // add the text color as white
                    
                    Text(headSub) // sub heading text
                        .font(.system(size: 14, weight: .medium, design: .rounded))// make it bold and rounded the sub heading
                        .foregroundColor(.white.opacity(0.8)) // add the text color as white with opacity
                }
                
                Spacer() // bring the componenet to top side
                
                Image(systemName: "chevron.right") // add the icon of chevron
                    .font(.system(size: 15, weight: .bold)) // make the icon bold and size
                    .foregroundColor(.white.opacity(0.5)) // add the color as white with opacity
            }
            .padding(15) // add the required padding to icon
            .background( // BG section
                RoundedRectangle(cornerRadius: 15) // make the border radius
                    .fill(Color.white.opacity(0.08)) // add color with opacity
                    .overlay( // overlay features
                        RoundedRectangle(cornerRadius: 14) // make the corner radius
                            .stroke(Color.white.opacity(0.16), lineWidth: 1) // add landwidth and necessary opacity
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1) // set optional scable while pressing
            .animation(.interactiveSpring(), value: isPressed) // animation effect whiloe pressing
        }
        .buttonStyle(PlainButtonStyle()) // make the default button style 
    }
}
