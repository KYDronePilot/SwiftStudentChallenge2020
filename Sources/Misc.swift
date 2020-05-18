import SwiftUI

/// A custom button for use throughout the playground.
struct CustomButton<Label: View>: View {
    /// Action performed on press.
    var action: () -> Void

    /// Button label.
    var label: Label

    /// Current scale effect of button.
    @State var scaleEffect: CGFloat = 1

    /// Current radius of the button background blur.
    @State var backgroundBlurRadius: CGFloat = 6

    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: { self.action() }) {
            self.label
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue)
                        .shadow(
                            color: Color(.sRGBLinear, white: 0, opacity: 0.23),
                            radius: self.backgroundBlurRadius, y: 3
                        )
                )
                .scaleEffect(self.scaleEffect)
                .transition(.scale)
                .onHover { isInFrame in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        self.scaleEffect = isInFrame ? 1.05 : 1.0
                        self.backgroundBlurRadius = isInFrame ? 12 : 6
                    }
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Apply a faint background shadow to a view.
struct FaintShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color.white
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 6, y: 3)
            )
    }
}

extension View {
    func faintShadow() -> some View {
        self.modifier(FaintShadow())
    }

    /// Allows a conditional modifier to be applied to a view.
    func conditionalModifier<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        condition ? AnyView(content(self)) : AnyView(self)
    }
}
