import SwiftUI

// MARK: - 🎨 Macaron Color Palette
extension Color {
    static let bgShowcase = Color(red: 0.98, green: 0.97, blue: 0.95) // Creamy Off-White
    
    // Low Saturation, High Brightness Macaron Colors
    static let clayVanilla = Color(red: 1.0, green: 0.95, blue: 0.8)
    static let clayMint = Color(red: 0.76, green: 0.95, blue: 0.85)
    static let clayPink = Color(red: 1.0, green: 0.85, blue: 0.88)
    static let clayLavender = Color(red: 0.88, green: 0.85, blue: 0.95)
    static let clayBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    
    static let textPrimary = Color(red: 0.4, green: 0.38, blue: 0.35) // Warm Grey/Brown
    static let textSecondary = Color(red: 0.6, green: 0.58, blue: 0.55)
    
    // Helper to make a color slightly darker for shadows
    func darker(by percentage: CGFloat = 0.2) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(max(brightness - percentage, 0)), opacity: Double(alpha))
    }
}

// MARK: - 🧱 Clay Effect Modifier
struct ClayEffect: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat = 25
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // 1. Top-Left High Light (Inflated look)
            .shadow(color: .white.opacity(0.8), radius: 8, x: -6, y: -6)
            // 2. Bottom-Right Shadow (Depth)
            .shadow(color: color.darker(by: 0.15), radius: 8, x: 6, y: 6)
    }
}

extension View {
    func clayEffect(color: Color, cornerRadius: CGFloat = 25) -> some View {
        self.modifier(ClayEffect(color: color, cornerRadius: cornerRadius))
    }
    
    // Global rounded font style
    func softFont(_ style: Font.TextStyle = .body, weight: Font.Weight = .bold) -> some View {
        self.font(.system(style, design: .rounded).weight(weight))
            .foregroundColor(.textPrimary)
    }
}
