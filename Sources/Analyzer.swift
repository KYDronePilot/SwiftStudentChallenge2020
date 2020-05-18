import SwiftUI

/// UI for controlling the decision tree generator.
struct AnalyzerUI: View {
    var algorithmAnalyzers: [UIAlgorithm.Type]
    
    @Binding var treeToDisplay: TreeValueNode

    @Binding var numberOfElements: Int
    @Binding var baselineAlgorithm: Int
    @Binding var newAlgorithm: Int

    @Binding var baselineAvgComparisons: Double?
    @Binding var newAvgComparisons: Double?
    @Binding var baselinePrunedCount: Int?
    @Binding var newPrunedCount: Int?

    @Binding var baselineTree: DecisionTreeNode?
    @Binding var newTree: DecisionTreeNode?

    @Binding var baselineAlgorithmName: String?
    @Binding var newAlgorithmName: String?

    /// Callback to switch to the tree view.
    var viewTreeTrigger: () ->  Void

    /// Get the names of algorithms which can be analyzed.
    ///
    /// - Returns: Names of algorithms
    private func algorithmNames() -> [String] {
        algorithmAnalyzers.map { algorithm in algorithm.meta.name }
    }

    /// Check whether or not a result has been generated.
    ///
    /// - Returns: Whether a result has been generated
    private func hasResults() -> Bool {
        baselineAvgComparisons != nil
        && newAvgComparisons != nil
        && baselinePrunedCount != nil
        && newPrunedCount != nil
    }

    /// Analyze both the algorithms.
    private func analyzeAlgorithms() {
        baselineTree = algorithmAnalyzers[baselineAlgorithm].init(arraySize: numberOfElements).analyze()
        newTree = algorithmAnalyzers[newAlgorithm].init(arraySize: numberOfElements).analyze()

        // Update statistics
        baselineAvgComparisons = baselineTree?.averagePathLength()
        newAvgComparisons = newTree?.averagePathLength()
        baselinePrunedCount = baselineTree?.prunedNodeCount()
        newPrunedCount = newTree?.prunedNodeCount()
        // Update current names
        baselineAlgorithmName = algorithmAnalyzers[baselineAlgorithm].meta.name
        newAlgorithmName = algorithmAnalyzers[newAlgorithm].meta.name
    }

    /// Convert/load the baseline decision tree and make it visible.
    func viewBaselineTree() {
        let convertedTree = TreeValueNode.convertDecisionTree(treeNode: baselineTree as? DecisionTreeComparisonNode)
        if convertedTree != nil {
            treeToDisplay = convertedTree!
            viewTreeTrigger()
        }
    }

    /// Convert/load the new decision tree and make it visible.
    func viewNewTree() {
        let convertedTree = TreeValueNode.convertDecisionTree(treeNode: newTree as? DecisionTreeComparisonNode)
        if convertedTree != nil {
            treeToDisplay = convertedTree!
            viewTreeTrigger()
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Sorting Algorithm Decision Tree Analyzer")
                .font(.largeTitle)
            Divider()
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
            VStack {
                Parameters(
                    algorithms: algorithmNames(),
                    minElementCount: 2,
                    maxElementCount: 4,
                    elementCount: $numberOfElements,
                    baselineAlgorithm: $baselineAlgorithm,
                    newAlgorithm: $newAlgorithm
                )
                .frame(maxWidth: 600)
                CustomButton(action: {
                    withAnimation {
                        self.analyzeAlgorithms()
                    }
                }) {
                    Text("Analyze")
                }
                .padding(.vertical, 15)
            }
            if self.hasResults() {
                Divider()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                VStack {
                    Text("Results")
                        .font(.headline)
                        .padding(.bottom, 25)
                    HStack(alignment: .center, spacing: 40) {
                        Results(
                            algorithmName: $baselineAlgorithmName,
                            resultType: .baseline,
                            newAvgComparisonCount: self.baselineAvgComparisons,
                            newPrunedNodesCount: self.baselinePrunedCount,
                            viewTreeTrigger: self.viewBaselineTree
                        )
                        Results(
                            algorithmName: $newAlgorithmName,
                            resultType: .new,
                            newAvgComparisonCount: self.newAvgComparisons,
                            oldAvgComparisonCount: self.baselineAvgComparisons,
                            newPrunedNodesCount: self.newPrunedCount,
                            oldPrunedNodesCount: self.baselinePrunedCount,
                            viewTreeTrigger: self.viewNewTree
                        )
                    }
                }
            }
        }
    }
}

/// Decision tree display component for the analyzer.
struct AnalyzerTreeDisplay: View {
    /// Root node of the decision tree.
    @Binding var rootNode: TreeValueNode

    /// Callback to switch back to the analyzer UI.
    var backButtonTrigger: () ->  Void

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Spacer()
                        TreeNode(sourceNode: self.rootNode, extraScaleFactor: 1)
                        Spacer()
                    }
                    .frame(minWidth: proxy.size.width)
                    .padding(.bottom, 15)
                }
                CustomButton(action: {
                    self.backButtonTrigger()
                }) {
                    Text("Back")
                }
            }
        }
    }
}

/// Wrapper component for analyzer UI and tree display.
struct AnalyzerWrapper: View {
    /// Views that can be displayed.
    enum ViewDisplayed {
        case analyzer, treeDisplay
    }
    
    /// Algorithm analyzers
    var algorithmAnalyzers: [UIAlgorithm.Type]

    /// Which view is currently being display.
    @State var viewDisplayed: ViewDisplayed = .analyzer

    /// Root node of tree to display if on tree display view.
    @State var currentTree: TreeValueNode = .init(value: .init(value: ""), children: [], meta: .init(nodeType: .comparison))

    /// Number of elements to use when generating decision trees.
    @State var numberOfElements = 3

    /// Index of the sorting algorithm to use as a baseline.
    @State var baselineAlgorithm = 0

    /// Index of the sorting algorithm to use for comparing.
    @State var newAlgorithm = 0

    /// Average number of comparisons made in the baseline algorithm tree.
    @State var baselineAvgComparisons: Double?

    /// Average number of comparisons made in the new algorithm tree.
    @State var newAvgComparisons: Double?

    /// Number of pruned nodes in the baseline algorithm tree.
    @State var baselinePrunedCount: Int?

    /// Number of pruned nodes in the new algorithm tree.
    @State var newPrunedCount: Int?

    /// The baseline algorithm tree generated.
    @State var baselineTree: DecisionTreeNode? = .init()

    /// The new algorithm tree generated.
    @State var newTree: DecisionTreeNode? = .init()

    /// Name of the baseline algorithm (updated when an analysis is run)
    @State var baselineAlgorithmName: String?

    /// Name of the new algorithm (updated when an analysis is run)
    @State var newAlgorithmName: String?

    @ViewBuilder var body: some View {
        if viewDisplayed == .analyzer {
            AnalyzerUI(
                algorithmAnalyzers: algorithmAnalyzers,
                treeToDisplay: $currentTree,
                numberOfElements: $numberOfElements,
                baselineAlgorithm: $baselineAlgorithm,
                newAlgorithm: $newAlgorithm,
                baselineAvgComparisons: $baselineAvgComparisons,
                newAvgComparisons: $newAvgComparisons,
                baselinePrunedCount: $baselinePrunedCount,
                newPrunedCount: $newPrunedCount,
                baselineTree: $baselineTree,
                newTree: $newTree,
                baselineAlgorithmName: $baselineAlgorithmName,
                newAlgorithmName: $newAlgorithmName
            ) {
                withAnimation {
                    self.viewDisplayed = .treeDisplay
                }
            }
        } else {
            AnalyzerTreeDisplay(rootNode: $currentTree) {
                withAnimation {
                    self.viewDisplayed = .analyzer
                }
            }
            .transition(.opacity)
        }
    }
}
