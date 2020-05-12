//
//  DecisionTreeGenerator.swift
//  SwiftChallengeProject
//
//  Created by Michael Galliers on 5/8/20.
//  Copyright © 2020 Michael Galliers. All rights reserved.
//

import Foundation


/// Simple stack abstraction.
class Stack<Item> {
    var items = [Item]()

    func push(item: Item) {
        items.append(item)
    }

    func pop() -> Item? {
        items.popLast()
    }

    func peek() -> Item? {
        items.last
    }

    func isEmpty() -> Bool {
        items.isEmpty
    }

    func size() -> Int {
        items.count
    }
}

/// Simple FIFO queue abstraction.
class Queue<Item> {
    var items = [Item]()

    func enqueue(item: Item) {
        items.append(item)
    }

    func dequeue() -> Item? {
        items.isEmpty ? nil : items.removeFirst()
    }

    func isEmpty() -> Bool {
        items.isEmpty
    }
}

/// Dummy values which the sorting algorithm can be given to sort.
///
/// Key Features:
///
/// - The comparison functions are overridden such that we can get execution control when a comparison is being made by
///   the sorting algorithm.
///   - This is used to see what elements are being compared and to control what execution path the algorithm will take
///     next.
class SortableItem: Comparable {
    // Abstraction (to the n-th degree) of symbols to use when sorting.
    enum Symbol: Character, CaseIterable {
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
        case E = "E"
        case F = "F"
        case G = "G"
        case H = "H"
        case I = "I"
        case J = "J"
        case K = "K"
        case L = "L"
        case M = "M"
        case N = "N"
        case O = "O"
        case P = "P"
        case Q = "Q"
        case R = "R"
        case S = "S"
        case T = "T"
        case U = "U"
        case V = "V"
        case W = "W"
        case X = "X"
        case Y = "Y"
        case Z = "Z"
    }

    /// Operators used in comparisons.
    enum ComparisonOperator: String {
        case lessThan = "<"
        case greaterThan = ">"
        case equal = "=="
        case notEqual = "!="
    }

    /// Subset of operators which are relational.
    static let RelationalOperators: Set<ComparisonOperator> = [.lessThan, .greaterThan]

    /// Negations of comparison operators (when considering only unique values).
    static let ComparisonOperatorNegations: [ComparisonOperator: ComparisonOperator] = [
        .lessThan: .greaterThan,
        .greaterThan: .lessThan,
        .equal: .notEqual,
    ]

    /// Analyzer instance this item is being used by.
    let analyzer: AlgorithmAnalyzer

    /// Symbol of this item instance.
    let value: Symbol

    /// Link the new item with an analyzer and give it a symbolic value.
    ///
    /// - Parameters:
    ///   - analyzer: Analyzer instance to link with
    ///   - value: Symbolic value of the item
    init(analyzer: AlgorithmAnalyzer, value: Symbol) {
        self.analyzer = analyzer
        self.value = value
    }

    /// Generate a list of items using sequential symbols.
    ///
    /// - Parameters:
    ///   - count: Number of items to generate
    ///   - analyzer: Analyzer to link them to
    ///
    /// - Returns: Array of new items
    static func generateSequentialItems(ofCount count: Int, withAnalyzer analyzer: AlgorithmAnalyzer) -> [SortableItem] {
        (0 ..< count).map { i in
            SortableItem.init(analyzer: analyzer, value: Symbol.allCases[i])
        }
    }

    /// Intercept less-than comparisons, passing on to the analyzer and returning its decision.
    static func < (lhs: SortableItem, rhs: SortableItem) -> Bool {
        lhs.analyzer.compareHandler(comparison: .init(operand1: lhs.value, operand2: rhs.value, compOperator: .lessThan))
    }

    /// Intercept greater-than comparisons, passing on to the analyzer and returning its decision.
    static func > (lhs: SortableItem, rhs: SortableItem) -> Bool {
        lhs.analyzer.compareHandler(comparison: .init(operand1: lhs.value, operand2: rhs.value, compOperator: .greaterThan))
    }

    /// Less-than or equal-to not yet implemented.
    static func <= (lhs: SortableItem, rhs: SortableItem) -> Bool {
        fatalError("This operator is not yet supported.")
    }

    /// Greater-than or equal-to not yet implemented.
    static func >= (lhs: SortableItem, rhs: SortableItem) -> Bool {
        fatalError("This operator is not yet supported.")
    }

    /// Intercept equal-to comparisons, passing on to the analyzer and returning its decision.
    static func == (lhs: SortableItem, rhs: SortableItem) -> Bool {
        lhs.analyzer.compareHandler(comparison: .init(operand1: lhs.value, operand2: rhs.value, compOperator: .equal))
    }

    /// Intercept not equal-to comparisons, passing on to the analyzer and returning its decision.
    static func != (lhs: SortableItem, rhs: SortableItem) -> Bool {
        lhs.analyzer.compareHandler(comparison: .init(operand1: lhs.value, operand2: rhs.value, compOperator: .notEqual))
    }
}

/// Represents a comparison between two values.
struct Comparison: Equatable, Hashable, CustomStringConvertible {
    /// First operand
    let operand1: SortableItem.Symbol

    /// Second operand
    let operand2: SortableItem.Symbol

    /// The operator
    let compOperator: SortableItem.ComparisonOperator

    /// String representation of comparison
    var description: String {
        "\(operand1.rawValue) \(compOperator.rawValue) \(operand2.rawValue)"
    }

    /// Get the negation of this comparison.
    ///
    /// - Returns: Negation of this comparison
    func negate() -> Comparison {
        Comparison(operand1: operand1, operand2: operand2, compOperator: SortableItem.ComparisonOperatorNegations[compOperator]!)
    }

    /// Normalize the comparison to make equating easier.
    ///
    /// - Returns: Normalized, equivalent comparison
    private func normalize() -> Comparison {
        if operand1.rawValue > operand2.rawValue {
            let comparison = SortableItem.RelationalOperators.contains(self.compOperator) ? SortableItem.ComparisonOperatorNegations[self.compOperator]! : self.compOperator
            return Comparison(operand1: operand2, operand2: operand1, compOperator: comparison)
        }
        return self
    }

    /// Check if two comparisons are equivalent.
    static func == (lhs: Comparison, rhs: Comparison) -> Bool {
        let lhsNormalized = lhs.normalize()
        let rhsNormalized = rhs.normalize()
        return (
            lhsNormalized.compOperator == rhsNormalized.compOperator
            && lhsNormalized.operand1 == rhsNormalized.operand1
            && lhsNormalized.operand2 == rhsNormalized.operand2
        )
    }

    /// Hash the operator.
    func hash(into hasher: inout Hasher) {
        let normalized = normalize()
        hasher.combine(normalized.compOperator)
        hasher.combine(normalized.operand1)
        hasher.combine(normalized.operand2)
    }
}

/// A generic node in the decision tree.
class DecisionTreeNode {
}

/// Node holding a comparison in the tree.
class DecisionTreeComparisonNode: DecisionTreeNode, CustomStringConvertible {
    /// Frame with information about the comparison at this node.
    var comparisonFrame: ComparisonFrame?

    /// Left and right subtrees
    var leftNode: DecisionTreeNode?
    var rightNode: DecisionTreeNode?

    /// Use the comparison as the text of the node.
    var description: String {
        comparisonFrame!.comparisonMade.description
    }
}

/// Leaf node holding the resulting order of items at the end of an execution path.
class DecisionTreeResultNode: DecisionTreeNode, CustomStringConvertible {
    /// Array with resulting order of items
    let resultingItems: [SortableItem]

    init(withItems items: [SortableItem]) {
        resultingItems = items
    }

    /// Use the resulting items as the string representation of the result node.
    var description: String {
        let values = resultingItems.map { item -> String in
            String(item.value.rawValue)
        }
        return "[\(values.joined(separator: ", "))]"
    }
}

/// Hold information about a comparison and outcome made during execution.
///
/// Also holds a reference to the tree node at this comparison for node linking purposes.
class ComparisonFrame {
    /// The comparison that was made.
    let comparisonMade: Comparison

    /// The chosen outcome of the comparison.
    let outcome: Bool

    /// Tree node back-referencing this comparison.
    var treeNode: DecisionTreeComparisonNode

    init(comparison: Comparison, outcome: Bool, treeNode: DecisionTreeComparisonNode) {
        comparisonMade = comparison
        self.outcome = outcome
        // Add the tree node ref and backref
        self.treeNode = treeNode
        self.treeNode.comparisonFrame = self
    }

    /// Init without a tree node (create a new one).
    convenience init(comparison: Comparison, outcome: Bool) {
        self.init(comparison: comparison, outcome: outcome, treeNode: .init())
    }

    /// Truth comparison formed by the comparison and its outcome.
    ///
    /// This is basically a fact about the items being sorted which we can later use to check for consistency. For
    /// example, if, in order to get where we are in the execution path, we chose the outcome of `true` for the
    /// comparison `A > B`, then `A > B` is a "truth" of that execution path. We can thus use that to say `A > B` with
    /// an outcome of `false` would not be valid, and neither would `A < B` with an outcome of `true` be valid, since
    /// they violate previous assumptions. Thus, those nodes are pruned.
    ///
    /// Returns: The "truth" formed by this frame's comparison and outcome
    func truth() -> Comparison {
        outcome ? comparisonMade : comparisonMade.negate()
    }

    /// Break the circular relationship with the associated tree node.
    ///
    /// This should be done to drop a no longer needed comparison frame and tree node.
    func deinitNodeRelationship() {
        treeNode.comparisonFrame = nil
    }
}

/// A stack for tracking the execution path of the program through the decision tree.
class PathTrackerStack: Stack<ComparisonFrame> {
    /// Set of truths: comparisons which denote decisions made in the stack (which new stack frames must be consistent
    /// with)
    var truthSet = Set<Comparison>()

    /// Generate a queue of comparison results which must be returned to restore the execution state of the sorting
    /// algorithm.
    ///
    /// Returns: Queue of restoring outcomes
    func generateStateRestorationQueue() -> Queue<Bool> {
        let queue = Queue<Bool>()
        for item in items {
            queue.enqueue(item: item.outcome)
        }
        return queue
    }

    /// Add the frame's truth to the truth set and link the previous tree node after pushing.
    ///
    /// - Parameter item: Frame to push
    override func push(item: ComparisonFrame) {
        let topFrame = peek()
        super.push(item: item)
        truthSet.insert(item.truth())
        // If there was a top frame on the stack, link its tree node to the new frame's; else, exit (this is the root)
        guard let previousFrame = topFrame else {
            return
        }
        if previousFrame.outcome {
            // True branches left
            previousFrame.treeNode.leftNode = item.treeNode
        } else {
            // False branches right
            previousFrame.treeNode.rightNode = item.treeNode
        }
    }

    /// Remove the frame's truth from the truth set after popping, if value is popped.
    ///
    /// - Returns: Frame popped, if at least one on stack
    override func pop() -> ComparisonFrame? {
        let item = super.pop()
        if item != nil {
            truthSet.remove(item!.truth())
        }
        return item
    }

    /// Check if a frame is valid, given the items already on the stack.
    ///
    /// - Parameter frame: Frame to check
    /// - Returns: Whether frame is valid
    func checkIfFrameValid(frame: ComparisonFrame) -> Bool {
        // Get the opposite of the frame's truth
        let oppositeTruth = frame.truth().negate()
        // Check if the opposite truth already exists, making the original invalid
        return !truthSet.contains(oppositeTruth)
    }
}

class AlgorithmAnalyzer {
    /// Different modes of operation that the program can be in.
    enum OperationMode {
        case exploratory
        case stateRestoration
    }

    /// Analyzer errors.
    enum AlgorithmAnalyzerError: Error {
        case terminatedInStateRestorationMode
    }

    /// Size of the array to run the sorting algorithm on.
    private let arraySize: Int

    /// Stack to keep track of what comparisons were made and what their outcomes were.
    private let pathTrackerStack = PathTrackerStack()

    /// Current mode of operation (starts exploring)
    private var currentOperationMode = OperationMode.exploratory

    /// Current items being sorted
    private var currentSortingItems = [SortableItem]()

    /// State restoration queue
    private var stateRestorationQueue = Queue<Bool>()

    init(arraySize: Int) {
        self.arraySize = arraySize
    }


    /// Get an array of items to sort.
    ///
    /// - Returns: Array of sortable items
    private func getSortingItems() -> [SortableItem] {
        SortableItem.generateSequentialItems(ofCount: arraySize, withAnalyzer: self)
    }

    /// Analyze the algorithm's execution paths, generating its decision tree structure.
    ///
    /// - Returns: Root node of the decision tree
    func analyze() -> DecisionTreeNode? {
        currentSortingItems = getSortingItems()

        // Traverse each execution path
        while true {
            algorithm(items: &currentSortingItems)

            // Add the leaf tree node for the path taken
            addResultNode()
            // Prepare for next path, exiting if none left
            if !prepareNextPath() {
                return pathTrackerStack.pop()?.treeNode
            }
        }
    }

    /// Handler for when a comparison was made in the sorting algorithm.
    ///
    /// - Parameter comparison: Comparison which is being made
    ///
    /// - Returns: Outcome of the comparison which should then be returned
    func compareHandler(comparison: Comparison) -> Bool {
        // Handle based on the mode of operation
        switch currentOperationMode {
        case .exploratory:
            return handleComparisonWhileExploring(comparison: comparison)
        case .stateRestoration:
            return handleComparisonWhileRestoringState(comparison: comparison)
        }
    }

    /// Add a result (leaf) node to the decision tree.
    private func addResultNode() {
        // Get the last comparison frame added, if one was
        guard let topFrame = pathTrackerStack.peek() else {
            return
        }
        // Create the result node and link the last tree comparison node to it based on the outcome
        let newNode = DecisionTreeResultNode(withItems: currentSortingItems)
        if topFrame.outcome {
            // True branches left
            topFrame.treeNode.leftNode = newNode
        } else {
            // False branches right
            topFrame.treeNode.rightNode = newNode
        }
    }

    /// Prepare for analyzing the algorithm down its next execution path.
    ///
    /// - Returns: Whether there is still at least one more path to traverse
    private func prepareNextPath() -> Bool {
        while true {
            guard let topFrame = pathTrackerStack.pop() else {
                // No more paths
                return false
            }
            // If last path was off the true branch, try the false branch
            if topFrame.outcome {
                let newFrame = ComparisonFrame(comparison: topFrame.comparisonMade, outcome: false, treeNode: topFrame.treeNode)
                // If not valid, restart and check another frame
                if !pathTrackerStack.checkIfFrameValid(frame: newFrame) {
                    newFrame.deinitNodeRelationship()
                    continue
                }
                // It's valid, so push it
                pathTrackerStack.push(item: newFrame)
                // Reset sorting items
                currentSortingItems = getSortingItems()
                // Load up the state restoration queue and put in state restoration mode
                stateRestorationQueue = pathTrackerStack.generateStateRestorationQueue()
                currentOperationMode = .stateRestoration
                return true
            }
            // If the last frame, put it back on the stack and signify that we are done
            if pathTrackerStack.isEmpty() {
                pathTrackerStack.push(item: topFrame)
                return false
            }
        }
    }

    /// Try to add a new comparison frame to the stack.
    ///
    /// - Parameters:
    ///   - comparison: Comparison of frame
    ///   - outcome: Outcome of the comparison
    ///
    /// - Returns: Whether or not it could be added
    private func tryToAddFrame(comparison: Comparison, outcome: Bool) -> Bool {
        let newFrame = ComparisonFrame(comparison: comparison, outcome: outcome)

        // If valid, push it
        if pathTrackerStack.checkIfFrameValid(frame: newFrame) {
            pathTrackerStack.push(item: newFrame)
            return true
        }
        // Else, deinit the frame
        newFrame.deinitNodeRelationship()
        return false
    }

    /// Handle a comparison while exploring the current execution path.
    ///
    /// - Parameter comparison: Comparison being made
    ///
    /// - Returns: Outcome of the comparison
    private func handleComparisonWhileExploring(comparison: Comparison) -> Bool {
        // Try to add a frame with the true outcome
        if !tryToAddFrame(comparison: comparison, outcome: true) {
            // Try to add a frame with the false outcome
            if !tryToAddFrame(comparison: comparison, outcome: false) {
                // One of the outcomes must be valid
                fatalError("Sorting function not valid; current execution path is impossible.")
            }
            return false
        }
        return true
    }

    /// Handle a comparison while in state restoration mode.
    ///
    /// - Parameter comparison: Comparison being made
    ///
    /// - Returns: Outcome of comparison
    private func handleComparisonWhileRestoringState(comparison: Comparison) -> Bool {
        // Dequeue and return decisions until none are left
        if !stateRestorationQueue.isEmpty() {
            return stateRestorationQueue.dequeue()!
        }
        // If none left, switch back to exploratory and let the exploring function handle it
        currentOperationMode = .exploratory
        return handleComparisonWhileExploring(comparison: comparison)
    }

    /// The sorting algorithm to be analyzed.
    ///
    /// Must be overridden and implemented in a subclass.
    ///
    /// - Parameter items: List of items to be sorted
    func algorithm(items: inout [SortableItem]) {
        fatalError("You must override this method with your own algorithm.")
    }
}

class BubbleSortAlgorithm: AlgorithmAnalyzer {
    override func algorithm(items: inout [SortableItem]) {
        for i in 1 ..< items.count {
            for j in 0 ..< items.count - i {
                if items[j] > items[j + 1] {
                    let temp = items[j]
                    items[j] = items[j + 1]
                    items[j + 1] = temp
                }
            }
        }
    }
}

class InsertionSortAlgorithm: AlgorithmAnalyzer {
    override func algorithm(items: inout [SortableItem]) {
        var a = items
        for x in 1..<a.count {
            var y = x
            while y > 0 && a[y] < a[y - 1] {
                a.swapAt(y - 1, y)
                y -= 1
            }
        }
    }
}
