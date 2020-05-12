//
//  TreeNode.swift
//  SwiftChallengeProject
//
//  Created by Michael Galliers on 5/11/20.
//  Copyright © 2020 Michael Galliers. All rights reserved.
//

import SwiftUI

struct TreeNode: View {
    var sourceNode: TreeValueNode
    var maxDepth: Int
    
    var body: some View {
            Group {
                if sourceNode.value.value != "" && !sourceNode.isLeaf {
                    VStack {
//                        if !sourceNode.isLeaf {
                        TreeComparisonCircle(text: sourceNode.value.value, scaleFactor: 1.8 / CGFloat((maxDepth + 1) * 3))
                            // Add the center anchor of this node
                            .anchorPreference(key: NodeCentersKey.self, value: .center) { anchor in
                                [self.sourceNode.value.id: anchor]
                            }
//                        }
                        HStack(alignment: .top) {
                            ForEach(sourceNode.children, id: \.value.id, content: { child in
                                TreeNode(sourceNode: child, maxDepth: self.maxDepth)
                            })
                        }
                    }
                    .backgroundPreferenceValue(NodeCentersKey.self) { (centers) in
                        GeometryReader { proxy in
                            ForEach(self.sourceNode.children.filter({ child -> Bool in child.value.value != "" && centers[self.sourceNode.value.id] != nil && centers[child.value.id] != nil }), id: \.value.id) { child in
                                LabeledBranchLine(
                                    from: proxy[centers[self.sourceNode.value.id]!],
                                    to: proxy[centers[child.value.id]!],
                                    branchText: child.parentBranch.rawValue,
                                    scale: 1.2 / CGFloat((self.maxDepth + 1))
                                )
                            }
                        }
                    }
                } else if (sourceNode.isLeaf) {
                    TreeResultNode(text: sourceNode.value.value, scaleFactor: 1.8 / CGFloat((maxDepth + 1) * 3))
                    // Add the center anchor of this node
                    .anchorPreference(key: NodeCentersKey.self, value: .center) { anchor in
                        [self.sourceNode.value.id: anchor]
                    }
                } else {
                    Spacer()
                    .frame(width: 30, height: 30)
                }
        }
    }
}

public struct FullView: View {
    @State var tree = getExampleTree()!
    
    public init() {}
    
    public var body: some View {
        
        ScrollView(.horizontal, showsIndicators: true) {
            TreeNode(sourceNode: tree, maxDepth: tree.maxDepth)
            .padding(12)
        }
        .frame(width: 500, height: 500)
    }
}

///// Tree node with lines extending downward to child nodes.
//struct TreeNodeWithBareBranches: View {
//    var node: TreeValueNode
//
//    var body: some View {
//
//    }
//}

//extension CGPoint: VectorArithmetic {
//    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
//        lhs - rhs
//    }
//
//    public mutating func scale(by rhs: Double) {
//        <#code#>
//    }
//
//    public var magnitudeSquared: Double {
//        <#code#>
//    }
//
//    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
//        <#code#>
//    }
//
//
//}

struct LabeledBranchLine: View {
    var from: CGPoint
    var to: CGPoint
    var branchText: String
    var scale: CGFloat
    
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
                .background(Circle().fill(Color.white))
                .position(Self.middlePoint(p1: from, p2: to))
        )
    }
}

/// Line connecting tree nodes
struct BranchLine: Shape {
    var from: CGPoint
    var to: CGPoint

//    var animatableData: AnimatablePair<CGPoint, CGPoint> {
//        get {AnimatablePair(from, to)}
//        set {
//            from = newValue.first
//            to = newValue.second
//        }
//    }
    
    private func pointAlongLine(factor: CGFloat) -> CGPoint {
        CGPoint(x: (from.x + to.x) / factor, y: (from.y + to.y) / factor)
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
    typealias CentersType = [ObjectIdentifier: Anchor<CGPoint>]
    static var defaultValue = CentersType()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { (current, _) in current }
    }
}

/// Preference key for holding center points of branch lines.
//struct BranchLineCenterKey: PreferenceKey {
//    typealias CentersType = Anchor<CGPoint>?
//    static var defaultValue = nil
//
//    static func reduce(value: inout Value, nextValue: () -> Value) {
//        value.merge(nextValue()) { (current, _) in current }
//    }
//}


class UniqueString: Identifiable {
    let value: String
    
    init(value: String) {
        self.value = value
    }
}

struct TreeValueNode {
    enum ParentBranch: String {
        case left = "Yes"
        case right = "No"
    }

    let value: UniqueString
    var children: [TreeValueNode]
    let isLeaf: Bool
    var maxDepth = 0
    var parentBranch: ParentBranch = .left

    static func convertDecisionTree(treeNode: DecisionTreeNode?) -> TreeValueNode? {
        // Do nothing if nil
        guard treeNode != nil else {
            return nil
        }
        var node = treeNode as! DecisionTreeComparisonNode
        var newNode = TreeValueNode(
                value: UniqueString(value: node.description),
                children: [],
                isLeaf: false
        )
        let val1 = convertDecisionTree(treeNode: node.leftNode, parent: &newNode, branch: .left)
        let val2 = convertDecisionTree(treeNode: node.rightNode, parent: &newNode, branch: .right)
        newNode.maxDepth = max(val1, val2)
        return newNode
    }

    static func convertDecisionTree(treeNode: DecisionTreeNode?, parent: inout TreeValueNode, branch: ParentBranch) -> Int {
        // Do nothing if nil
        guard treeNode != nil else {
            parent.children.append(.init(value: .init(value: ""), children: [], isLeaf: false))
            return 0
        }
        var newNode: TreeValueNode
        if let node = treeNode as? DecisionTreeComparisonNode {
            newNode = .init(
                    value: UniqueString(value: node.description),
                    children: [],
                    isLeaf: false
            )
            let val1 = convertDecisionTree(treeNode: node.leftNode, parent: &newNode, branch: .left)
            let val2 = convertDecisionTree(treeNode: node.rightNode, parent: &newNode, branch: .right)
            newNode.maxDepth = max(val1, val2)
        } else {
            let node = treeNode as! DecisionTreeResultNode
            newNode = .init(
                    value: UniqueString(value: node.description),
                    children: [],
                    isLeaf: true
            )
            newNode.maxDepth = 0
        }
        newNode.parentBranch = branch
        parent.children.append(newNode)
        return newNode.maxDepth
    }
}

func getExampleTree() -> TreeValueNode? {
    let analyzer = BubbleSortAlgorithm(arraySize: 4)
    return TreeValueNode.convertDecisionTree(treeNode: analyzer.analyze())
}

struct TreeNode_Previews: PreviewProvider {
//    static var stackFrame = ComparisonFrame(comparison: Comparison(operand1: .A, operand2: .B, compOperator: SortableItem.ComparisonOperator.lessThan), outcome: true)
        
    static var previews: some View {
        VStack {
            FullView()
        }
//        .frame(width: 800, height: 500)
        .background(Color.white)
    }
}
