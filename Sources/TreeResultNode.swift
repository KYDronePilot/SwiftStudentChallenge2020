import SwiftUI

/// For displaying a decision tree result node.
struct TreeResultNode: View {
    /// Text to put in the node.
    var text: String

    /// Scale factor to control the size.
    var scaleFactor: CGFloat

    /// Color of the node.
    var color: Color

    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(.system(size: 15 * scaleFactor))
            .padding(6)
            .frame(width: 5.97 * scaleFactor * CGFloat(text.count) + 20, height: 30 * scaleFactor)
            .background(Rectangle().stroke(Color.black))
            .background(Rectangle().fill(Color.white))
            .padding(2)
            .padding(.vertical, 8)
    }
}
