import SwiftUI

/// For displaying an animated decision tree in the tutorial slides.
struct AnimatedTree: View {
    /// Root node of the tree.
    var rootNode: TreeValueNode?

    /// Scale factor for the tree.
    var treeScale: CGFloat?

    @ViewBuilder var body: some View {
        if rootNode != nil {
            Spacer()
            TreeNode(sourceNode: rootNode!, extraScaleFactor: treeScale ?? 1)
            Spacer()
        } else {
            EmptyView()
        }
    }
}
