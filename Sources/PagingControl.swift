import SwiftUI

/// Tutorial text source.
let textBlocks = [
    "intro": [
        """
        As a new computer science student learning about sorting\
         algorithms, you're likely trying to get a mental image of how they\
         work and why one is faster than the other.
        """
    ],
    "enterDecisionTree": [
        """
        Enter Decision Trees!
        """,
        """
        They give a way to visualize every possible sequence of comparisons made when\
         an algorithm sorts a fixed-length array of some unknown values.
        """,
        """
        Now, let's see how they work!
        """,
    ],
    "scenario": [
        """
        Let's look at one of the simplest sorting algorithms: Bubble Sort.
        """,
        """
        Also let's say we're sorting an array of 3 items with some unknown values: [A, B, C].
        """,
        """
        The first comparison we make is A > B.
        """,
    ],
    "branching1": [
        """
        If A > B is true, we swap those elements, and on the next loop iteration,\
         make the comparison A > C.
        """,
    ],
    "branching2": [
        """
        If A > B is NOT true, we move on without swapping and make the comparison\
         B > C next.
        """,
    ],
    "results": [
        """
        We keep doing this until the algorithm stops, and then put down the\
         final order of the items.
        """,
        """
        The more comparisons needed to reach a result, the slower and worse the\
         algorithm.
        """,
    ],
    "pruning": [
        """
        Some comparisons only have one outcome, since the other is invalid and\
         thus removed (pruned).
        """,
        """
        In this example B > A can't be true, since we already assumed A > B was true\
         further up the tree (sorting unique items).
        """,
        """
        Each pruned outcome is bad because it slows down the algorithm\
         with an unnecessary comparison.
        """,
    ],
    "efficiency": [
        """
        A sorting algorithm's decision tree let's you quickly see how efficient the\
         algorithm might be.
        """,
        """
        So, now it's your turn!
        """,
        """
        Next is a decision tree analyzer, which lets you generate\
         and compare decision trees for different sorting algorithms.
        """,
        """
        You can also add your own algorithm to the playground (or modify an existing one),\
         restart the playground, and see its tree and how it performs!
        """,
    ],
]

/// Bubble sort tree structure used in tutorial.
let bubbleTreeStructure = TreeValueNode(
        value: .init(value: "A > B"),
        children: [
            TreeValueNode(
                    value: .init(value: "A > C"),
                    children: [
                        TreeValueNode(
                                value: .init(value: "B > C"),
                                children: [
                                    TreeValueNode(
                                            value: .init(value: "[C, B, A]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .left, hidden: true)
                                    ),
                                    TreeValueNode(
                                            value: .init(value: "[B, C, A]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .right, hidden: true)
                                    ),
                                ],
                                meta: .init(nodeType: .comparison, parentBranch: .left, hidden: true)
                        ),
                        TreeValueNode(
                                value: .init(value: "B > A"),
                                children: [
                                    TreeValueNode(
                                            value: .init(value: ""),
                                            children: [],
                                            meta: .init(nodeType: .pruned, parentBranch: .left, hidden: true)
                                    ),
                                    TreeValueNode(
                                            value: .init(value: "[B, A, C]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .right, hidden: true)
                                    ),
                                ],
                                meta: .init(nodeType: .comparison, parentBranch: .right, hidden: true)
                        ),
                    ],
                    meta: .init(nodeType: .comparison, parentBranch: .left, hidden: true)
            ),
            TreeValueNode(
                    value: .init(value: "B > C"),
                    children: [
                        TreeValueNode(
                                value: .init(value: "A > C"),
                                children: [
                                    TreeValueNode(
                                            value: .init(value: "[C, A, B]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .left, hidden: true)
                                    ),
                                    TreeValueNode(
                                            value: .init(value: "[A, C, B]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .right, hidden: true)
                                    ),
                                ],
                                meta: .init(nodeType: .comparison, parentBranch: .left, hidden: true)
                        ),
                        TreeValueNode(
                                value: .init(value: "A > B"),
                                children: [
                                    TreeValueNode(
                                            value: .init(value: ""),
                                            children: [],
                                            meta: .init(nodeType: .pruned, parentBranch: .left, hidden: true)
                                    ),
                                    TreeValueNode(
                                            value: .init(value: "[A, B, C]"),
                                            children: [],
                                            meta: .init(nodeType: .result, parentBranch: .right, hidden: true)
                                    ),
                                ],
                                meta: .init(nodeType: .comparison, parentBranch: .right, hidden: true)
                        ),
                    ],
                    meta: .init(nodeType: .comparison, parentBranch: .right, hidden: true)
            )
        ],
        meta: .init(nodeType: .comparison)
)

/// Two-node tree used in tutorial.
var twoNodeTree = TreeValueNode(
        value: .init(value: "A > B"),
        children: [
            TreeValueNode(
                    value: .init(value: "A > C"),
                    children: [],
                    meta: .init(nodeType: .comparison, parentBranch: .left, hidden: true)
            ),
            TreeValueNode(
                    value: .init(value: "B > C"),
                    children: [],
                    meta: .init(nodeType: .comparison, parentBranch: .right, hidden: true)
            )
        ],
        meta: .init(nodeType: .comparison, hidden: true)
)

/// Bubble sort code for tutorial.
var bubbleSortCode = """
                     func bubbleSort(items: inout [SortableItem]) {
                         for i in 1 ..< items.count {
                             for j in 0 ..< items.count - i {
                                 if items[j] > items[j + 1] {
                                     items.swapAt(j, j + 1)
                                 }
                             }
                         }
                     }
                     """

/// Data for each tutorial page.
struct TutorialPageData {
    var initialData: StepData
    var animationFunctions: [() -> StepData]
}

/// Data for each of the pages.

var introData: StepData = .init(
    explanationTextBlocks: textBlocks["intro"]!,
    array: [.init(value: "A"), .init(value: "B"), .init(value: "C")],
    isArrayBlurred: true
)

var enterData: StepData = .init(
    animationTimer: Timer.publish(every: 0.5, on: .main, in: .common).autoconnect(),
    explanationTextBlocks: textBlocks["enterDecisionTree"]!,
    treeStructure: bubbleTreeStructure,
    treeScale: 1.3
)

var bubbleSortExample1: StepData = .init(
    animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
    explanationTextBlocks: textBlocks["scenario"]!,
    codeBlock: bubbleSortCode,
    selectedCodeLine: 0,
    array: [.init(value: "A"), .init(value: "B"), .init(value: "C")],
    treeStructure: twoNodeTree,
    treeScale: 2
)

var bubbleSortBranching1: StepData = .init(
    animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
    explanationTextBlocks: textBlocks["branching1"]!,
    codeBlock: bubbleSortCode,
    selectedCodeLine: 0,
    array: [.init(value: "A"), .init(value: "B"), .init(value: "C")],
    treeStructure: twoNodeTree,
    treeScale: 2
)

var bubbleSortBranching2: StepData = .init(
        animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
        explanationTextBlocks: textBlocks["branching1"]! + textBlocks["branching2"]!,
        codeBlock: bubbleSortCode,
        selectedCodeLine: 0,
        array: [.init(value: "A"), .init(value: "B"), .init(value: "C")],
        treeStructure: twoNodeTree,
        treeScale: 2
)

var bubbleSortResults: StepData = .init(
        animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
        explanationTextBlocks: textBlocks["results"]!,
        array: [.init(value: "A"), .init(value: "B"), .init(value: "C")],
        treeStructure: bubbleTreeStructure,
        treeScale: 1.3
)

var bubbleSortPruning: StepData = .init(
        animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
        explanationTextBlocks: textBlocks["pruning"]!,
        treeStructure: bubbleTreeStructure,
        treeScale: 1.3
)

var bubbleSortSummary: StepData = .init(
        animationTimer: Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(),
        explanationTextBlocks: textBlocks["efficiency"]!,
        treeStructure: bubbleTreeStructure,
        treeScale: 1.3
)

/// Animation closures for each page.

let tutorialPages = [
    1: TutorialPageData(
        initialData: introData,
        animationFunctions: [
            {() -> StepData in
                var newData = introData
                newData.array?.swapAt(0, 1)
                introData = newData
                return newData
            },
            {() -> StepData in
                var newData = introData
                newData.array?.swapAt(1, 2)
                introData = newData
                return newData
            },
            {() -> StepData in
                var newData = introData
                newData.array?.swapAt(0, 1)
                introData = newData
                return newData
            },
            {() -> StepData in
                var newData = introData
                newData.array?.swapAt(0, 2)
                introData = newData
                return newData
            },
        ]
    ),
    2: TutorialPageData(
        initialData: enterData,
        animationFunctions: [
            {() -> StepData in
                enterData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].children[0].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].children[0].children[0].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].children[0].children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[0].children[1].children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].children[0].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].children[0].children[0].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].children[0].children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].children[1].meta.hidden = false
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure?.children[1].children[1].children[1].meta.hidden = false
                newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                enterData = newData
                return newData
            },
            {() -> StepData in
                var newData = enterData
                newData.treeStructure = bubbleTreeStructure
                newData.animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                enterData = newData
                return newData
            },
        ]
    ),
    3: TutorialPageData(
            initialData: bubbleSortExample1,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortExample1
                    newData.animationTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
                    newData.selectedCodeLine = 0
                    newData.treeStructure?.meta.hidden = true
                    bubbleSortExample1 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortExample1
                    newData.selectedCodeLine = 3
                    bubbleSortExample1 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortExample1
                    newData.treeStructure?.meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortExample1 = newData
                    return newData
                },
            ]
    ),
    4: TutorialPageData(
            initialData: bubbleSortBranching1,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortBranching1
                    newData.animationTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
                    newData.selectedCodeLine = 3
                    newData.treeStructure?.meta.hidden = false
                    newData.treeStructure?.children[0].meta.hidden = true
                    bubbleSortBranching1 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortBranching1
                    newData.selectedCodeLine = 4
                    newData.array?.swapAt(0, 1)
                    bubbleSortBranching1 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortBranching1
                    newData.selectedCodeLine = 3
                    newData.treeStructure?.children[0].meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortBranching1 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortBranching1
                    newData.animationTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
                    newData.array?.swapAt(0, 1)
                    newData.selectedCodeLine = 3
                    newData.treeStructure?.meta.hidden = false
                    newData.treeStructure?.children[0].meta.hidden = true
                    bubbleSortBranching1 = newData
                    return newData
                },
            ]
    ),
    5: TutorialPageData(
            initialData: bubbleSortBranching2,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortBranching2
                    newData.animationTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
                    newData.selectedCodeLine = 3
                    newData.treeStructure?.meta.hidden = false
                    newData.treeStructure?.children[0].meta.hidden = true
                    newData.treeStructure?.children[1].meta.hidden = true
                    bubbleSortBranching2 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortBranching2
                    newData.selectedCodeLine = 5
                    bubbleSortBranching2 = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortBranching2
                    newData.selectedCodeLine = 3
                    newData.treeStructure?.children[1].meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortBranching2 = newData
                    return newData
                },
            ]
    ),
    6: TutorialPageData(
            initialData: bubbleSortResults,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortResults
                    newData.animationTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
                    bubbleSortResults = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortResults
                    newData.treeStructure?.children[0].meta.hidden = false
                    newData.array?.swapAt(0, 1)
                    bubbleSortResults = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortResults
                    newData.treeStructure?.children[0].children[0].meta.hidden = false
                    newData.array?.swapAt(1, 2)
                    bubbleSortResults = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortResults
                    newData.treeStructure?.children[0].children[0].children[0].meta.hidden = false
                    newData.array?.swapAt(0, 1)
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortResults = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortResults
                    newData.animationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                    newData.treeStructure?.children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[0].children[0].meta.hidden = true
                    newData.array?.swapAt(0, 2)
                    bubbleSortResults = newData
                    return newData
                },
            ]
    ),
    7: TutorialPageData(
            initialData: bubbleSortPruning,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.animationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    newData.treeStructure?.children[0].children[1].children[0].value = .init(value: "[A, B, C]")
                    newData.treeStructure?.children[0].children[1].children[0].meta.nodeType = .result
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].meta.hidden = false
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[0].meta.hidden = false
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[0].children[0].meta.hidden = false
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[0].children[1].meta.hidden = false
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[1].meta.hidden = false
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[1].children[0].meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[1].children[0].meta.color = .red
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[1].children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[1].children[0].meta.color = .black
                    newData.animationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.treeStructure?.children[0].children[1].children[1].meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortPruning = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortPruning
                    newData.animationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                    newData.treeStructure?.children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[0].children[0].meta.hidden = true
                    newData.treeStructure?.children[0].children[0].children[1].meta.hidden = true
                    newData.treeStructure?.children[0].children[1].meta.hidden = true
                    newData.treeStructure?.children[0].children[1].children[1].meta.hidden = true
                    bubbleSortPruning = newData
                    return newData
                },
            ]
    ),
    8: TutorialPageData(
            initialData: bubbleSortSummary,
            animationFunctions: [
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                    newData.treeStructure?.children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].children[0].children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].children[0].children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[0].children[1].children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].children[0].children[0].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].children[0].children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].children[1].meta.hidden = false
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure?.children[1].children[1].children[1].meta.hidden = false
                    newData.animationTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
                    bubbleSortSummary = newData
                    return newData
                },
                {() -> StepData in
                    var newData = bubbleSortSummary
                    newData.treeStructure = bubbleTreeStructure
                    newData.animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                    bubbleSortSummary = newData
                    return newData
                },
            ]
    ),
]

/// Root controller for all of the pages.
public struct RootPageController: View {
    /// Algorithm analyzers
    public var algorithmAnalyzers: [UIAlgorithm.Type]
    
    /// Current page displayed.
    @State var currentPage = 0

    /// Current animation index.
    @State var currentAnimation = 0

    /// Initial page data, before animations make changes.
    @State var initialData = introData
    
    public init(algorithmAnalyzers: [UIAlgorithm.Type]) {
        self.algorithmAnalyzers = algorithmAnalyzers
    }

    /// Transition to the next page.
    public func nextPage() {
        self.currentAnimation = 0
        withAnimation {
            self.currentPage += 1

            if self.currentPage >= 1 && self.currentPage <= 8 {
                self.initialData = tutorialPages[self.currentPage]!.initialData
            }
        }
    }

    public var body: some View {
        VStack {
            if currentPage == 0 {
                StartPage(triggerNextPage: {
                    self.nextPage()
                }, triggerShowAnalyzer: {
                    withAnimation {
                        self.currentPage = 10
                    }
                })
            }
            else if currentPage >= 1 && currentPage <= 8 {
                StepFrame(
                    currentAnimation: $currentAnimation,
                    data: $initialData,
                    animationFunctions: tutorialPages[currentPage]!.animationFunctions,
                    triggerNextSlide: { self.nextPage() }
                )
            } else {
                AnalyzerWrapper(algorithmAnalyzers: algorithmAnalyzers)
            }
        }
        .frame(width: 900, height: 650)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}
