import Cocoa
import SwiftUI
import PlaygroundSupport
import Foundation


/// Now it's your turn to try adding a new algorithm!
///
/// As an example, try adding the commented-out cocktail shaker sort algorithm.
///
/// Steps:
/// - Uncomment its analyzer class below.
/// - Uncomment the class's entry in the `algorithmAnalyzers` array below the class,
///   to make it show up in the UI.
/// - Restart the playground, skip to the analyzer, and see how the algorithm performs!



///// Cocktail Shaker Sort algorithm analyzer.
//class CocktailShakerSortAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
//    static var meta = AlgorithmMeta(name: "Cocktail Shaker Sort")
//
//    override func algorithm(items: inout [SortableItem]) {
//        var start = 0
//        var end = items.count - 1
//        var hasSwapped = true
//
//        while hasSwapped {
//            hasSwapped = false
//
//            // Bubble sort forward
//            for i in start ..< end {
//                if items[i] > items[i + 1] {
//                    items.swapAt(i, i + 1)
//                    hasSwapped = true
//                }
//            }
//
//            // If nothing swapped, everything is sorted
//            guard hasSwapped else {
//                return
//            }
//            hasSwapped = false
//            end -= 1
//
//            // Bubble sort backwards
//            for i in stride(from: end - 1, through: start, by: -1) {
//                if items[i] > items[i + 1] {
//                    items.swapAt(i, i + 1)
//                    hasSwapped = true
//                }
//            }
//            start += 1
//        }
//    }
//}

/// Algorithms to include in the UI.
public let algorithmAnalyzers: [UIAlgorithm.Type] = [
    SelectionSortAlgorithm.self,
    BubbleSortAlgorithm.self,
    InsertionSortAlgorithm.self,
    ShellSortAlgorithm.self,
//    CocktailShakerSortAlgorithm.self,
]


/// If you'd like to create or add your own algorithm, below is a template analyzer
/// class.
///
/// Steps:
/// - Add your algorithm to the `algorithm` function.
/// - Add the analyzer class type to the `algorithmAnalyzers` array above.
/// - Restart the playground, and see how it performs!
///
/// Restrictions:
/// - The algorithm can't use `>=` or `<=` operators when comparing array items
///   (the analyzer assumes only unique elements are being sorted).
/// - Algorithms must operate in a deterministic manner (i.e., can't rely on random
///   sources (yet!)).
///   - Example: Quicksort


/// A new sorting algorithm written by you.
public class MyNewSortingAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
    public static var meta = AlgorithmMeta(name: "My Sorting Algorithm")

    public override func algorithm(items: inout [SortableItem]) {
        // Your new algorithm goes here.
    }
}

/// Selection Sort algorithm analyzer.
public class SelectionSortAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
    public static var meta = AlgorithmMeta(name: "Selection Sort")

    public override func algorithm(items: inout [SortableItem]) {
        for i in 0 ..< items.count - 1 {
            var minI = i
            for j in i + 1 ..< items.count {
                if items[minI] > items[j] {
                    minI = j
                }
            }
            items.swapAt(i, minI)
        }
    }
}

/// Bubble Sort algorithm analyzer.
public class BubbleSortAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
    public static var meta = AlgorithmMeta(name: "Bubble Sort")

    public override func algorithm(items: inout [SortableItem]) {
        for i in 1 ..< items.count {
            for j in 0 ..< items.count - i {
                if items[j] > items[j + 1] {
                    items.swapAt(j, j + 1)
                }
            }
        }
    }
}

/// Insertion Sort algorithm analyzer.
public class InsertionSortAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
    public static var meta = AlgorithmMeta(name: "Insertion Sort")

    public override func algorithm(items: inout [SortableItem]) {
        for i in 1 ..< items.count {
            var j = i

            while j > 0 && items[j - 1] > items[j] {
                items.swapAt(j - 1, j)
                j -= 1
            }
        }
    }
}

/// Shell Sort algorithm analyzer.
public class ShellSortAlgorithm: AlgorithmAnalyzer, UIAlgorithm {
    public static var meta = AlgorithmMeta(name: "Shell Sort")

    public override func algorithm(items: inout [SortableItem]) {
        var gap = items.count / 2

        while gap > 0 {
            for i in gap ..< items.count {
                var j = i

                while j >= gap && items[j - gap] > items[j] {
                    items.swapAt(j, j - gap)
                    j -= gap
                }
            }
            gap /= 2
        }
    }
}

PlaygroundPage.current.setLiveView(RootPageController(algorithmAnalyzers: algorithmAnalyzers))
