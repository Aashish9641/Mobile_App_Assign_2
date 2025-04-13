import SwiftUI // importing the swift UI for better framework

struct SearchBar: View { // liking the UI view for search bar
    @Binding var text: String // adding the binding variable that links external part

    var body: some View { // added the var body view
        HStack { // Adding the horizontal stack
            TextField("Search.....", text: $text) // adding the text filed
                .padding(7) // make the inside padding a
                .padding(.horizontal, 24) // add padding in top section and left
                .background(Color(.systemGray6)) // added the system color as gray
                .cornerRadius(9) // link the corner radius of 9
                .overlay( // it sits on the top to add the different icons
                    HStack { // adde dthe horizontal stack
                        Image(systemName: "magnifyingglass") // added the icon of glass
                            .foregroundColor(.gray) // add the gray color to make it better
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // adding the several frame alighment for better visibility
                            .padding(.leading, 7) // linked padding 7 leading

                        if !text.isEmpty { // if the text is not nil then show the clear button as X
                            Button(action: {
                                text = "" // make it clear the search text
                            }) {
                                Image(systemName: "multiply.circle.fill") // add the icon of X
                                    .foregroundColor(.gray) // add suitable gray color
                                    .padding(.trailing, 7) // fix padding to right side
                            }
                        }
                    }
                )
        }
        .padding(.horizontal) // added required padding around the H stack 
    }
}
