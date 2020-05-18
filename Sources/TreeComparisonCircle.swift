import SwiftUI

/// For displaying a decision tree comparison node.
struct TreeComparisonCircle: View {
    /// Text to put in the node.
    var text: String

    /// Scale factor to control the size.
    var scaleFactor: CGFloat

    /// Color of the node.
    var color: Color
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(.system(size: 14 * scaleFactor))
            .frame(width: 50 * scaleFactor, height: 50 * scaleFactor)
            .background(Circle().stroke(Color.black))
            .background(Circle().fill(Color.white))
            .padding(8)
    }
}
