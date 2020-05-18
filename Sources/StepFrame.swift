import SwiftUI
import Combine

/// A section of tutorial text.
struct TextSection: View {
    /// The text itself.
    var text: String

    var body: some View {
        Text(text)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .faintShadow()
    }
}

/// Sidebar section of tutorial text.
struct TextSections: View {
    /// Raw text sections.
    var textList: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(textList, id: \.self) { text in
                TextSection(text: text)
            }
        }
    }
}

/// Data for a particular step in the tutorial.
struct StepData {
    /// Current animation frame.
    var currentAnimationFrame = 0

    /// Timer for triggering animations.
    var animationTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    /// BLocks of text giving an explanation for the current step.
    var explanationTextBlocks = [String]()

    /// Block of code used to help explain the step.
    var codeBlock: String?

    /// Which of the code lines should be pointed to.
    var selectedCodeLine: Int?

    /// Array of items used to help explain the step.
    var array: [UniqueString]?

    /// Should the array have a blur effect?
    var isArrayBlurred: Bool?

    /// Decision tree used to help explain the step.
    var treeStructure: TreeValueNode?

    /// Scale of the tree, to make sure it fits in the frame.
    var treeScale: CGFloat?
}

/// Wrapper for code block to add spacing.
struct CodeBlockWrapper: View {
    var codeBlock: String?
    var selectedCodeLine: Int?
    var isVisible: Bool

    @ViewBuilder var body: some View {
        if isVisible {
            Spacer()
            CodeDisplay(code: codeBlock!, selectedLine: selectedCodeLine!)
            Spacer()
        } else {
            EmptyView()
        }
    }
}

/// A particular step in the tutorial.
struct StepFrame: View {
    /// Index of the current animation.
    @Binding var currentAnimation: Int

    /// Data state for the frame.
    @Binding var data: StepData

    /// Functions which make appropriate changes to the data for the next animation.
    var animationFunctions: [() -> StepData]

    /// Callback to switch to next slide.
    var triggerNextSlide: () -> Void

    /// Starts next animation.
    func nextAnimation() {
        data = animationFunctions[currentAnimation]()
        currentAnimation = (currentAnimation + 1) % animationFunctions.count
    }

    /// Check whether the code block should be made visible.
    ///
    /// - Returns: Whether the code block is visible
    private func isCodeBlockVisible() -> Bool {
        data.codeBlock != nil && data.selectedCodeLine != nil
    }

    /// Check whether the sortable array should be made visible.
    ///
    /// - Returns: Whether the sortable array is visible
    private func isSortableArrayVisible() -> Bool {
        data.array != nil
    }

    /// Check whether the tree should be made visible.
    ///
    /// - Returns: Whether the tree is visible
    private func isTreeVisible() -> Bool {
        data.treeStructure != nil
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                TextSections(textList: self.data.explanationTextBlocks)
                    .frame(width: 250)
                    .animation(.default)
                VStack {
                    CodeBlockWrapper(
                        codeBlock: self.data.codeBlock,
                        selectedCodeLine: self.data.selectedCodeLine,
                        isVisible: isCodeBlockVisible()
                    )
                    .animation(.default)
                    if isCodeBlockVisible() && isSortableArrayVisible() || isCodeBlockVisible() && isTreeVisible() {
                        Divider()
                            .padding(.horizontal, 30)
                    }
                    SortableArray(items: self.data.array, blurred: self.data.isArrayBlurred ?? false)
                        .animation(.default)
                    if isSortableArrayVisible() && isTreeVisible() {
                        Divider()
                            .padding(.horizontal, 30)
                    }
                    AnimatedTree(rootNode: self.data.treeStructure, treeScale: self.data.treeScale)
                        .animation(.default)
                }
                .frame(maxWidth: .infinity)
            }
            .onReceive(self.data.animationTimer) { _ in
                self.nextAnimation()
            }
            .padding(20)
            CustomButton(action: triggerNextSlide) {
                Text("Next")
            }
            .padding(.bottom, 15)
        }
    }
}
