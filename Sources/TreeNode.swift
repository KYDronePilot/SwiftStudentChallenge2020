import SwiftUI

/// Core recursive tree rendering component.
struct TreeNode: View {
    /// Root node for current subtree.
    var sourceNode: TreeValueNode

    /// An extra scale factor to help change the tree size.
    var extraScaleFactor: CGFloat = 1

    @ViewBuilder var body: some View {
        if sourceNode.meta.nodeType == .comparison {
            VStack {
                // The node itself
                TreeComparisonCircle(
                    text: sourceNode.value.value,
                    scaleFactor: extraScaleFactor * 1.8 / 3,
                    color: sourceNode.meta.color
                )
                .conditionalModifier(sourceNode.meta.hidden) { content in
                    content.hidden()
                }
                // Add the center anchor of this node if not hidden
                .conditionalModifier(!sourceNode.meta.hidden) { content in
                    content.anchorPreference(key: NodeCentersKey.self, value: .center) { anchor in
                        [self.sourceNode.value.id: anchor]
                    }
                }
                // The node's children, rendered recursively
                HStack(alignment: .top) {
                    ForEach(sourceNode.children, id: \.value.id, content: { child in
                        TreeNode(sourceNode: child, extraScaleFactor: self.extraScaleFactor)
                    })
                }
            }
            // Draw branches to children
            .backgroundPreferenceValue(NodeCentersKey.self) { (centers) in
                GeometryReader { proxy in
                    ForEach(self.sourceNode.children.filter{ child -> Bool in
                        child.value.value != "" && centers[self.sourceNode.value.id] != nil && centers[child.value.id] != nil
                    }, id: \.value.id) { child in
                        LabeledBranchLine(
                            from: proxy[centers[self.sourceNode.value.id]!],
                            to: proxy[centers[child.value.id]!],
                            branchText: child.meta.parentBranch.rawValue,
                            scale: self.extraScaleFactor * 1.2
                        )
                    }
                }
            }
        } else if (sourceNode.meta.nodeType == .result) {
            TreeResultNode(
                text: sourceNode.value.value,
                scaleFactor: extraScaleFactor * 1.8 / 3,
                color: sourceNode.meta.color
            )
            .conditionalModifier(sourceNode.meta.hidden) { content in
                content.hidden()
            }
            // Add the center anchor of this node if it is not hidden
            .conditionalModifier(!sourceNode.meta.hidden) { content in
                content.anchorPreference(key: NodeCentersKey.self, value: .center) { anchor in
                    [self.sourceNode.value.id: anchor]
                }
            }
        } else {
            Spacer()
            .frame(width: 30, height: 30)
        }
    }
}

/// For making the branch lines animatable.
extension CGPoint: VectorArithmetic {
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public mutating func scale(by rhs: Double) {
        x *= CGFloat(rhs)
        y *= CGFloat(rhs)
    }

    public var magnitudeSquared: Double {
        Double(x * x + y * y)
    }

    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

/// A branch line with text in the middle.
struct LabeledBranchLine: View {
    /// Start point.
    var from: CGPoint

    /// End point.
    var to: CGPoint

    /// Text to place in the middle.
    var branchText: String

    /// Scale factor for font.
    var scale: CGFloat

    /// Get the middle point of the line.
    static func middlePoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    var body: some View {
        BranchLine(from: from, to: to)
            .stroke(Color.black)
            .overlay(
                Text(branchText)
                    .font(.system(size: 8 * scale))
                    .foregroundColor(.black)
                    .background(Rectangle().fill(Color.white))
                    .position(Self.middlePoint(p1: from, p2: to))
            )
    }
}

/// Line connecting tree nodes.
struct BranchLine: Shape {
    /// Start point.
    var from: CGPoint

    /// End point.
    var to: CGPoint

    var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get {AnimatablePair(from, to)}
        set {
            from = newValue.first
            to = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            // Draw to before the midpoint
            path.move(to: self.from)
            path.addLine(to: self.to)
        }
    }
}

/// Preference key for holding center points of tree nodes.
struct NodeCentersKey: PreferenceKey {
    /// Map from node IDs to anchor points.
    typealias CentersType = [ObjectIdentifier: Anchor<CGPoint>]

    /// Starts as an empty dictionary.
    static var defaultValue = CentersType()

    /// Merge dictionaries.
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { (current, _) in current }
    }
}

/// Wrapper to make strings identifiable.
class UniqueString: Identifiable {
    /// Wrapped string.
    let value: String

    init(value: String) {
        self.value = value
    }
}

/// Metadata about a tree value node.
struct TreeMeta {
    /// Which branch from the parent is a node.
    enum ParentBranch: String {
        case left = "true"
        case right = "false"
    }

    /// The type of a node.
    enum NodeType {
        case comparison
        case result
        case pruned
    }

    /// Type of this node.
    var nodeType: NodeType

    /// Which branch from the parent this node is.
    var parentBranch: ParentBranch = .left

    /// Color of the node.
    var color: Color = .black

    /// Whether the node should be hidden.
    var hidden = false
}

/// Value based tree representation used for rendering.
struct TreeValueNode {
    /// Unique string value at this node.
    var value: UniqueString

    /// Children of this node.
    var children: [TreeValueNode]

    /// Metadata about the node.
    var meta: TreeMeta

    /// Convert a decision tree to a value tree.
    ///
    /// - Parameter treeNode: Root node of the decision tree
    ///
    /// - Returns: Value tree root node
    static func convertDecisionTree(treeNode: DecisionTreeComparisonNode?) -> TreeValueNode? {
        // Do nothing if nil
        guard treeNode != nil else {
            return nil
        }
        var newNode = TreeValueNode(
            value: .init(value: treeNode!.description),
            children: [],
            meta: .init(nodeType: .comparison)
        )
        convertDecisionTree(treeNode: treeNode!.leftNode, parent: &newNode, branch: .left)
        convertDecisionTree(treeNode: treeNode!.rightNode, parent: &newNode, branch: .right)
        return newNode
    }

    /// Convert internal decision tree node to value tree node.
    ///
    /// - Parameters:
    ///   - treeNode: The decision tree node
    ///   - parent: The node's parent value node
    ///   - branch: Which branch the node is on from its parent
    static func convertDecisionTree(treeNode: DecisionTreeNode?, parent: inout TreeValueNode, branch: TreeMeta.ParentBranch) {
        // Add pruned node if nil
        guard treeNode != nil else {
            parent.children.append(.init(
                    value: .init(value: ""),
                    children: [],
                    meta: .init(nodeType: .pruned, parentBranch: branch)
            ))
            return
        }
        var newNode: TreeValueNode

        // Convert as decision node
        if let node = treeNode as? DecisionTreeComparisonNode {
            newNode = .init(value: .init(value: node.description), children: [], meta: .init(nodeType: .comparison))
            convertDecisionTree(treeNode: node.leftNode, parent: &newNode, branch: .left)
            convertDecisionTree(treeNode: node.rightNode, parent: &newNode, branch: .right)
        } else {
            // Convert as result node
            let node = treeNode as! DecisionTreeResultNode
            newNode = .init(value: .init(value: node.description), children: [], meta: .init(nodeType: .result))
        }
        newNode.meta.parentBranch = branch
        parent.children.append(newNode)
    }
}
