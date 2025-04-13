import SwiftUI // importing the swift UI framework

struct InfoRow: View { // defining the Swift
    let icon: String // property to hold icon
    let label: String // label text
    let value: String // string for value text
    
    var body: some View { // main body to explain the view layout and content
        HStack { // add the horizontal stack
            Image(systemName: icon) // showing the icon for space
                .frame(width: 29) //adding the width for 29
                .foregroundColor(.purple) // set pruple color
            Text(label) // show the label text
            Spacer() // bring the vlaue to right end
            Text(value) // show the value text
                .foregroundColor(.gray) // add the gray text
        }
    }
}
