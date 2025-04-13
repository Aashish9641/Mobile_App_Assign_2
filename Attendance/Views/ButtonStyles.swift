
import SwiftUI // importing the swift UI framework

struct ScaleButtonStyle: ButtonStyle { // defining the custom button scale that confirm button
    func makeBody(configuration: Configuration) -> some View { // add the necessay body that how button looks
        configuration.label // added the real label of the button
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0) // execute the effect when the button clicked
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed) // animating of sacling transiting using teh ease out
    }
}
