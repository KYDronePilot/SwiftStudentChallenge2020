import SwiftUI

/// Text describing the percent difference between two values.
struct PercentDifferenceText: View {
    /// Is a larger number better or worse?
    enum HigherIs {
        case better
        case worse
    }

    /// New value's relation to the old.
    enum NewValueRelation {
        case higher
        case equal
        case lower
    }

    /// Custom yellow color.
    static let yellow: Color = .init(red: 0.6902, green: 0.6667, blue: 0.0078)

    /// Color maps
    static let HigherBetterColors: [NewValueRelation: Color] = [
        .higher: .green,
        .equal: yellow,
        .lower: .red,
    ]

    static let HigherWorseColors: [NewValueRelation: Color] = [
        .higher: .red,
        .equal: yellow,
        .lower: .green,
    ]

    /// Old value being compared
    var oldValue: Double

    /// New value being compared
    var newValue: Double

    /// Whether higher is better or worse
    var higherIs: HigherIs

    /// Get the new value's relation to the old.
    ///
    /// - Returns: New value's relation to old
    private func getNewValueRelation() -> NewValueRelation {
        if newValue > oldValue {
            return .higher
        } else if newValue < oldValue {
            return .lower
        } else {
            return .equal
        }
    }

    /// Get text color, based on whether new value is better or worse.
    ///
    /// - Returns: Text color
    private func color() -> Color {
        switch higherIs {
        case .better:
            return Self.HigherBetterColors[getNewValueRelation()]!
        case .worse:
            return Self.HigherWorseColors[getNewValueRelation()]!
        }
    }

    /// Calculate percent difference between values.
    ///
    /// - Returns: Percent difference
    private func percentDiff() -> Double {
        abs(((newValue - oldValue) / oldValue) * 100)
    }

    /// Get the formatted percentage difference value, but only if old/new values are not close to zero.
    ///
    /// If they are close to zero, the meaning of percent difference becomes useless.
    ///
    /// - Returns: Formatted percent value
    private func percentValue() -> String {
        guard abs(oldValue) >= 1 && abs(newValue) >= 1 else {
            return ""
        }
        // No value if no difference
        guard percentDiff() != 0 else {
            return ""
        }
        return String(format: "%.1f%% ", percentDiff())
    }

    /// Get the "better", "worse", or "ok" information labels to display based on the old/new values.
    ///
    /// - Returns: "better", "worse", or "ok" information labels
    private func betterWorse() -> String {
        switch getNewValueRelation() {
        case .lower:
            return higherIs == .worse ? "better 👍" : "worse 👎"
        case .higher:
            return higherIs == .better ? "better 👍" : "worse 👎"
        case .equal:
            return "ok 👌"
        }
    }
    
    var body: some View {
        Text("\(percentValue())\(betterWorse())")
            .foregroundColor(color())
    }
}

/// For displaying the results of a particular sorting algorithm.
struct Results: View {
    /// Types of algorithms which can be displayed.
    enum AlgorithmType: String {
        case baseline = "Baseline"
        case new = "New"
    }

    /// Name of the algorithm.
    @Binding var algorithmName: String?

    /// The actual type being displayed.
    var resultType: AlgorithmType

    /// Average number of comparisons for the new algorithm.
    var newAvgComparisonCount: Double?

    /// Average number of comparisons for the old algorithm.
    var oldAvgComparisonCount: Double?

    /// Number of pruned nodes for the new algorithm.
    var newPrunedNodesCount: Int?

    /// Number of pruned nodes for the old algorithm.
    var oldPrunedNodesCount: Int?

    /// Callback to enable the decision tree view.
    var viewTreeTrigger: () -> Void

    /// Check whether there are results to display.
    ///
    /// - Returns: Whether there are results
    private func hasResults() -> Bool {
        newAvgComparisonCount != nil && newPrunedNodesCount != nil
    }
    
    var body: some View {
        VStack {
            Text("\(resultType.rawValue): \(algorithmName ?? "")")
                .font(.subheadline)
            if hasResults() {
                HStack {
                    VStack(alignment: .trailing) {
                        Text("avg. number of comparisons:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("number of pruned nodes:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading) {
                        Text(String(format: "%.2f", newAvgComparisonCount!))
                            .fontWeight(.semibold)
                        Text(String(newPrunedNodesCount!))
                            .fontWeight(.semibold)
                    }
                    VStack(alignment: .leading) {
                        if oldAvgComparisonCount != nil {
                            PercentDifferenceText(
                                oldValue: oldAvgComparisonCount!,
                                newValue: newAvgComparisonCount!,
                                higherIs: .worse
                            )
                        }
                        if oldPrunedNodesCount != nil {
                            PercentDifferenceText(
                                oldValue: Double(oldPrunedNodesCount!),
                                newValue: Double(newPrunedNodesCount!),
                                higherIs: .worse
                            )
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            CustomButton(action: {
                withAnimation {
                    self.viewTreeTrigger()
                }
            }) {
                Text("View Tree")
            }
        }
        .frame(width: 350)
        .padding(15)
        .faintShadow()
        .transition(.opacity)
    }
}
