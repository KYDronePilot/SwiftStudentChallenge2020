import SwiftUI

/// An animated array representation in the UI.
struct SortableArray: View {
    /// Items in the array.
    var items: [UniqueString]?

    /// Should the array be blurred.
    var blurred: Bool

    /// Format the array into unique string parts.
    private func formattedArrayParts() -> [UniqueString]? {
        guard items != nil else {
            return nil
        }
        if items!.count == 0 {
            return [.init(value: "["), .init(value: "]")]
        }
        var res: [UniqueString] = [.init(value: "["), items![0]]
        for i in 1 ..< items!.count {
            res += [.init(value: ", "), items![i]]
        }
        return res + [.init(value: "]")]
    }

    @ViewBuilder var body: some View {
        if items != nil {
            Spacer()
            HStack {
                ForEach(formattedArrayParts()!, id: \.id) { part in
                    Text(part.value)
                        .font(.headline)
                        .padding(-2)
                    .conditionalModifier(self.blurred) { content in
                        content.blur(radius: 2)
                    }
                }
            }
            Spacer()
        } else {
            EmptyView()
        }
    }
}
