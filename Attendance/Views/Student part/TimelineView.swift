import SwiftUI // Imporitng the swift UI for better framework
import CoreData // management of the core database

@available(iOS 15.0, *) // make sure to run is ios 15
struct TimelineView: View { // make custom view for timelineview
    @EnvironmentObject var authVM: AuthViewModel // get the access of authentication
    @Environment(\.managedObjectContext) private var viewContext // access the core database saving and fetching
    @Environment(\.presentationMode) var presentationMode // used to dismiss the current view
    
    // using the state variables to keep teh content
    @State private var posNow = ""
    @State private var kinfPos: PostType = .global // state to find if it is global or particulr course
    @State private var courChoos: Course? // keeping the chosen course if ti type post
    @State private var dispCou = false // used toogle to display of the course picket sheet
    
    enum PostType { case global, course } // used enum to track post type
    
    @FetchRequest( // code to fetch all the core database
        sortDescriptors: [NSSortDescriptor(keyPath: \Post.timestamp, ascending: false)], // sorted the lates first and ascending order
        animation: .default) // add the animation as default
    private var posts: FetchedResults<Post> // fetching the consequences
    
    @FetchRequest( // code to get the available course for choosing
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)], // getting the course by latest or ascending order
        animation: .default) // make animation as defualt
    private var courses: FetchedResults<Course> // getting thje course conswquences
    
    var pickPostt: [Post] { // filtering the post based on course or glbola
        switch kinfPos { // switching the type
        case .global: // it execute wthether it is global
            return posts.filter { $0.isGlobal } // it returns the gloabl part only
        case .course: // case for course
            if let course = courChoos { // pick the course
                return posts.filter { $0.course == course } // pick the specific course in dropdown
            }
            return [] // returning the nil list if not choosen
        }
    }
    
    var body: some View { // main body part for the timeline section
        VStack(spacing: 0) { // vertical stack with 0 space
            VStack(spacing: 15) { // inner v stack for make post
                Picker("Post Type", selection: $kinfPos) { // select the post
                    Text("Global").tag(PostType.global) // adding the global option
                    Text("Course").tag(PostType.course) // set course option
                }
                .pickerStyle(SegmentedPickerStyle()) // set segement control style
                .padding(.horizontal) // add padding in horizontal side
                
                if kinfPos == .course { // when the course is chose
                    Button {
                        dispCou = true // show the chosen course
                    } label: {
                        HStack {
                            Text(courChoos?.name ?? "Choose Course") // text for choos the cousrse
                                .foregroundColor(courChoos == nil ? .gray : .primary) // adding the primary color as gray
                            
                            Spacer() // add the spaceer
                            
                            Image(systemName: "chevron.down") // set teh icon of chervon
                        }
                        .padding() // fix necessay padding
                        .background(Color(.secondarySystemBackground)) // add light gray BG
                        .cornerRadius(9) // Making the rounded corners
                    }
                    .padding(.horizontal) // set padding in horizontal area
                }
                
                TextEditor(text: $posNow) // using the text editor for post content
                    .frame(height: 99) // add the heigh
                    .padding() // add padding
                    .background(Color(.secondarySystemBackground)) // set BG color system
                    .cornerRadius(11) // corner radius
                    .padding(.horizontal) // H side padding
                
                Button { // added button
                    posMak() // caling the function to create posyt
                } label: {
                    HStack { // horiontal stack
                        Image(systemName: "paperplane.fill") // icon for the post
                        Text("Post") // set text as post
                    }
                    .frame(maxWidth: .infinity)// make stretch across width
                    .padding() // add padding
                    .background(Color.green) // add BG color as green
                    .foregroundColor(.white) // text color as white
                    .cornerRadius(10) // making the corner raidus
                }
                .disabled(posNow.isEmpty || (kinfPos == .course && courChoos == nil)) // disable the post if the course is nil in course side
                .padding(.horizontal) // add horizontal side padding
            }
            .padding(.vertical) // top side vertical padding
            .background(Color(.systemBackground)) // add system BG color
            .sheet(isPresented: $dispCou) { // latest course choose as sheet
                coursePic(courChoos: $courChoos) // bypass the binding picket
            }
            
            Divider() // divider the line
            
            List { // addiong the set of list of the posts
                if pickPostt.isEmpty { // if there is no post
                    VStack(spacing: 11) { //add the vertical stack spacing
                        Image(systemName: "message.fill") // add the icon
                            .font(.system(size: 40)) // add the size
                            .foregroundColor(.gray) // add color as gray
                        
                        Text(kinfPos == .global ? "No global posts yet" : "No posts for this course yet") // show the message if there is no posts
                            .font(.headline) // headline font added
                            .foregroundColor(.gray) // color as gray
                        
                        Text("Be the first to post!") // text to see to post first time
                            .font(.subheadline) // set teh subheading font
                            .foregroundColor(.gray) // add color as gray
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // make this content in center and add alignment
                    .padding() // set the required padding
                    .listRowSeparator(.hidden) // hidden operation after update
                } else {
                    ForEach(pickPostt) { post in // add loop through in each post
                        viewPo(post: post) // show the each post
                            .listRowSeparator(.hidden) // added the hidden feature
                            .listRowInsets(.init(top: 11, leading: 0, bottom: 11, trailing: 0)) // added padding in bottm top and set
                    }
                }
            }
            .listStyle(.plain) // modify the plain style
        }
        .navigationTitle(kinfPos == .global ? "Global Timeline" : "Course Timeline") // adding the titel for global time admn course time
        .navigationBarTitleDisplayMode(.inline) // style of inline title
    }
    
    private func posMak() { // function to make and save the post
        guard let student = authVM.studeRight else { return } // make sure the student is logged in
        
        let post = Post(context: viewContext) // make the new post object
        post.id = UUID() // assigning the new id
        post.content = posNow // add the content of the post
        post.timestamp = Date() // adding the timestamp
        post.isGlobal = kinfPos == .global // adding the type of the post
        post.author = student // add author of the post
        post.course = kinfPos == .course ? courChoos : nil // addigend the course if there is applicable
        
        PersistenceController.shared.save() // save the udpated part in core data
        posNow = "" // make it clear the post data
    }
}

struct viewPo: View { // show the single post
    let post: Post // post has to be showed
    
    var body: some View { // main entrance for this page
        VStack(alignment: .leading, spacing: 11) { // add veritcal stack with spaceing
            HStack(alignment: .top) { // add top side horizontal alignment
                Image(systemName: "person.crop.circle.fill") // link the icon as well
                    .font(.title2) // add the font size
                    .foregroundColor(.blue) // BG color as blue
                
                VStack(alignment: .leading, spacing: 3) { // vertical stack alignment and spacing 3
                    HStack { // horizontal side stack
                        Text(post.author?.name ?? "Unknown") // show the author name
                            .font(.subheadline) // add subline heading
                            .fontWeight(.semibold) // make it semi bold
                        
                        if let course = post.course, !post.isGlobal { // display the name of the course
                            Text("·") // text to display
                            Text(course.name ?? "Course")  // show course
                                .font(.caption) // make font in course
                                .foregroundColor(.purple) // set color as purple
                                .padding(4) // adding the padding
                                .background(Color.purple.opacity(0.1)) // set opacity
                                .cornerRadius(4) // add teh corner radius
                        }
                    }
                    
                    Text(gmDb(date: post.timestamp ?? Date())) // dispaly the formatted date
                        .font(.caption) // add font color
                        .foregroundColor(.gray) // add the color as gray
                }
                
                Spacer() // adding the spacer
            }
            
            Text(post.content ?? "") // show the content of the post
                .padding(.leading, 34) // add padding & leading
            
            HStack(spacing: 1) { // fix the horizontal spacing
                Button {
                    // setting Like action
                } label: {
                    HStack { // add the horizontal side stack
                        Image(systemName: "heart") // add the icon of heart
                        Text("Like") // add the text as like
                    }
                    .font(.caption) // add the content font
                }
                
                Button {
                    // adding the action of comment
                } label: {
                    HStack { // fixing the horizontal stack as well
                        Image(systemName: "text.bubble") // add the icon of bubble
                        Text("Comment") // show the text as comment s
                    }
                    .font(.caption) // add the caption of comments
                }
                
                Spacer() // fixing the spacer
            }
            .padding(.leading, 34) // set padding and leading 34
            .padding(.top, 6) // add padding in top side
            .foregroundColor(.gray) // add gary color
        }
        .padding() // add necessary padding
        .background(Color(.secondarySystemBackground)) // add BG as secondary color
        .cornerRadius(11) // make the corner radius
        .padding(.horizontal) // set the horizontal padding
    }
    
    private func gmDb(date: Date) -> String { // function to formate date
        let gatter = DateFormatter() // make date formatter
        gatter.dateStyle = .medium // using the medium date style
        gatter.timeStyle = .short // use short style time
        return gatter.string(from: date) // returning the format
    }
}

struct coursePic: View { // view to choose teh course
    @Environment(\.presentationMode) var presentationMode // enabling dismissing the sheet
    @Binding var courChoos: Course? // varibale to modify teh choosen course
    
    @FetchRequest( // adding the fetch request
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)], // setting the latest and ascending order
        animation: .default) // add default animation
    private var courses: FetchedResults<Course> // short fetch course
    
    var body: some View { // main entrance of this page
        NavigationView { // add nav bar
            List {
                ForEach(courses) { course in // using the loop through course
                    Button {
                        courChoos = course // set the choosen course
                        presentationMode.wrappedValue.dismiss() // fix dismissal course or sheet
                    } label: {
                        HStack {// adding the horizontal stack
                            Text(course.name ?? "Unknown Course") // show the course name
                            Spacer() // add spacer
                            if course == courChoos {
                                Image(systemName: "checkmark") // using the checkmark for choosen course
                                    .foregroundColor(.blue) // add color as blue
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Course") // add title for the course chooser
            .navigationBarTitleDisplayMode(.inline) // add inline text style
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { // set the cancel buton
                        presentationMode.wrappedValue.dismiss() // for cancel button dismissal 
                    }
                }
            }
        }
    }
}
