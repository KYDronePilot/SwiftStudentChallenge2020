import SwiftUI

/// For displaying NS attributed strings.
struct AttributedText: NSViewRepresentable {
    var attrString: NSAttributedString

    func makeNSView(context: Context) -> NSTextField {
        let label = NSTextField()
        label.isEditable = false
        label.isSelectable = false
        label.isBordered = false
        label.maximumNumberOfLines = 0
        return label
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.attributedStringValue = attrString
    }
}

/// Displays a block of code with minimal syntax highlighting.
struct CodeBlock: View {
    /// Code to display.
    var str: String

    /// Size of the font.
    var fontSize: CGFloat
    
    /// Some basic keywords to highlight.
    static let keywords: Set = ["class", "override", "func", "inout", "for", "in", "if", "let"]
    
    /// Format the code string.
    private func formatString() -> NSAttributedString {
        let nsStr = NSString(string: self.str)
        let attrString = NSMutableAttributedString(string: str)
        let fullRange = NSMakeRange(0, nsStr.length)
        
        // Give it a general code style
        attrString.addAttribute(
            .font,
            value: NSFont.monospacedSystemFont(ofSize: fontSize - 7, weight: .regular),
            range: fullRange
        )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        // Highlight keywords
        nsStr.enumerateSubstrings(in: fullRange, options: .byWords) { (substring, subrange, _, _) in
            guard substring != nil else {
                return
            }
            
            if Self.keywords.contains(substring!) {
                attrString.addAttribute(
                    .foregroundColor,
                    value: NSColor(red: 0.7098, green: 0.0078, blue: 0.5608, alpha: 1),
                    range: subrange
                )
            }
        }
        return attrString
    }
    
    var body: some View {
        AttributedText(attrString: formatString())
    }
}

/// Custom object to point to the current line of code for illustration purposes.
struct CodeLinePointer: View {
    /// Whether or not to show the shape.
    var isShown: Bool

    @ViewBuilder var body: some View {
        if isShown {
            GeometryReader { proxy in
                Path { path in
                    let width = proxy.size.width * 0.8
                    let height = proxy.size.height * 0.6
                    let blockWidth = width * 0.8
                    let middleHeight = proxy.size.height / 2
                    let leftEdge = (proxy.size.width - width) / 2
                    let topEdge = (proxy.size.height - height) / 2

                    path.move(to: CGPoint(x: leftEdge, y: topEdge))
                    path.addLines([
                        CGPoint(x: leftEdge + blockWidth, y: topEdge),
                        CGPoint(x: leftEdge + width, y: middleHeight),
                        CGPoint(x: leftEdge + blockWidth, y: topEdge + height),
                        CGPoint(x: leftEdge, y: topEdge + height),
                        CGPoint(x: leftEdge, y: topEdge),
                    ])
                }
                .fill(Color.init(NSColor.systemBlue))
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 6)
            }
        } else {
            Spacer()
        }
    }
}

/// Code gutter with line numbers and line pointer.
struct CodeGutter: View {
    /// Number of code lines.
    var numberOfLines: Int

    /// Current line to point to.
    var currentLine: Int

    /// Size of font to use.
    var fontSize: CGFloat

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                ForEach((0 ..< numberOfLines).map { i in i == currentLine ? "Yes" : "" }, id: \.self) { i in
                    CodeLinePointer(isShown: "Yes" == i)
                        .frame(width: 30, height: self.fontSize)
                }
            }.offset(y: -1)

            VStack(alignment: .trailing, spacing: 0) {
                ForEach((1 ... numberOfLines).map { i in String(i) }, id: \.self) { i in
                    Text(i)
                        .font(.custom("Courier", size: self.fontSize))
                }
            }
        }
    }
}

/// For displaying code snippets to the user.
struct CodeDisplay: View {
    /// Font size for code display.
    static let fontSize: CGFloat = 23

    /// Cody displayed in viewer.
    var code: String

    /// The current line of code to point to.
    var selectedLine: Int

    /// Get the number of lines in the code.
    ///
    /// - Returns: Number of lines of code
    private func numberOfLines() -> Int {
        code.components(separatedBy: "\n").count
    }

    var body: some View {
        HStack(alignment: .top) {
            CodeGutter(numberOfLines: numberOfLines(), currentLine: selectedLine, fontSize: Self.fontSize)
            Divider()
                .frame(height: Self.fontSize * CGFloat(numberOfLines()))
            CodeBlock(str: code, fontSize: Self.fontSize)
        }
    }
}
