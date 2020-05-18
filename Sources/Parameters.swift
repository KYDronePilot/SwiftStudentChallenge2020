import SwiftUI

/// Input parameters for analyzing a decision tree.
struct Parameters: View {
    /// Names of algorithm options.
    var algorithms: [String]

    /// Minimum number of elements that can be used when analyzing an algorithm.
    var minElementCount: Int

    /// Maximum number of elements that can be used when analyzing an algorithm.
    var maxElementCount: Int

    /// Indexed selections for inputs.
    @Binding var elementCount: Int
    @Binding var baselineAlgorithm: Int
    @Binding var newAlgorithm: Int

    var body: some View {
        VStack {
            Text("Parameters")
                .font(.headline)
            Form {
                Picker(selection: $elementCount, label: Text("Number of elements to sort")) {
                    ForEach(minElementCount ..< maxElementCount + 1, id: \.self) {
                        Text(String($0))
                    }
                }
                Text("Limited to max of 4 elements since more would generate trees too large to render.")
                    .font(.caption)
                Picker(selection: $baselineAlgorithm, label: Text("Baseline algorithm")) {
                    ForEach(0 ..< algorithms.count, id: \.self) {
                        Text(self.algorithms[$0])
                    }
                }
                Picker(selection: $newAlgorithm, label: Text("Experimental algorithm")) {
                    ForEach(0 ..< algorithms.count, id: \.self) {
                        Text(self.algorithms[$0])
                    }
                }
            }
        }
    }
}
