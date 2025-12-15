import SwiftUI

// MARK: - 🧸 Squishy Button
struct SquishyButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    
    @State private var isPressed = false
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            content
        }
        .buttonStyle(SquishyButtonStyle())
    }
}

struct SquishyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: configuration.isPressed)
    }
}

// MARK: - 🕳️ Inner Shadow (for text fields)
extension View {
    func innerShadow(cornerRadius: CGFloat = 20, color: Color = .gray.opacity(0.2)) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: 4)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .mask(RoundedRectangle(cornerRadius: cornerRadius))
        )
    }
}

struct ClayTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .softFont(.body)
            .padding()
            .background(Color.bgShowcase) // Slightly lighter than bg
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .white, radius: 2, x: 1, y: 1) // Bottom highlight
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(RoundedRectangle(cornerRadius: 20).fill(LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
            )
    }
}

// MARK: - 🍬 Jelly Toggle
struct JellyToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            // Track
            RoundedRectangle(cornerRadius: 30)
                .fill(isOn ? Color.clayMint : Color.gray.opacity(0.2))
                .frame(width: 60, height: 34)
                .animation(.spring(), value: isOn)
            
            // Thumb
            Circle()
                .fill(Color.white)
                .frame(width: 26, height: 26)
                .shadow(radius: 2, y: 1)
                .offset(x: isOn ? 12 : -12)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isOn)
        }
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation {
                isOn.toggle()
            }
        }
    }
}
