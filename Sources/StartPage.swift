import SwiftUI

/// Background of start page.
struct StartPageBackground: View {
    /// Tree structure to display.
    @State var tree = bubbleTreeStructure

    /// Make all tree nodes visible.
    func showNodes() {
        var newTree = tree
        newTree.children[0].meta.hidden = false
        newTree.children[0].meta.hidden = false
        newTree.children[0].children[0].meta.hidden = false
        newTree.children[0].children[0].children[0].meta.hidden = false
        newTree.children[0].children[0].children[1].meta.hidden = false
        newTree.children[0].children[1].meta.hidden = false
        newTree.children[0].children[1].children[1].meta.hidden = false
        newTree.children[1].meta.hidden = false
        newTree.children[1].children[0].meta.hidden = false
        newTree.children[1].children[0].children[0].meta.hidden = false
        newTree.children[1].children[0].children[1].meta.hidden = false
        newTree.children[1].children[1].meta.hidden = false
        newTree.children[1].children[1].children[1].meta.hidden = false
        tree = newTree
    }

    var body: some View {
        AnimatedTree(rootNode: tree, treeScale: 2.5)
            .onAppear() {
                self.showNodes()
            }
    }
}

/// Main start page view.
struct StartPage: View {
    /// Callback to show next page.
    var triggerNextPage: () -> Void

    /// Callback to jump to analyzer.
    var triggerShowAnalyzer: () -> Void

    var body: some View {
        VStack {
            Text("Exploring Sorting Algorithm Decision Trees")
                .font(.largeTitle)
                .padding(.top, 80)
            Spacer()
            HStack {
                CustomButton(action: triggerNextPage) {
                    Text("Begin!")
                }
                CustomButton(action: triggerShowAnalyzer) {
                    Text("Skip to Analyzer")
                }
            }
            .frame(height: 100)
        }
        .background(StartPageBackground().blur(radius: 5))
    }
}
