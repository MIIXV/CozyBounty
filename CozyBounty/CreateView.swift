import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: BountyStore
    
    @State private var title: String = ""
    @State private var selectedEmoji: String = "🧹"
    @State private var points: Double = 50
    @State private var isRecurring: Bool = false
    
    let emojis = ["🧹", "🍽️", "🐈", "🗑️", "👕", "🪴", "📚", "🧸"]
    
    var body: some View {
        ZStack {
            Color.bgShowcase.ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header
                HStack {
                    // Left spacer to balance
                    Image(systemName: "xmark").font(.title).opacity(0)
                        
                    Spacer()
                    
                    Text("捏个新任务")
                        .softFont(.title2, weight: .heavy)
                    
                    Spacer()
                    
                    // Right: Close Button (Unified Style)
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.textSecondary)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 5)
                            .shadow(color: .white, radius: 2, x: -2, y: -2)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // 1. Emoji Picker
                        VStack(alignment: .leading) {
                            Text("图标 (Emoji)")
                                .softFont(.headline)
                                .padding(.leading, 5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(emojis, id: \.self) { emoji in
                                        SquishyButton(action: {
                                            selectedEmoji = emoji
                                        }) {
                                            Text(emoji)
                                                .font(.system(size: 35))
                                                .frame(width: 65, height: 65)
                                                .background(selectedEmoji == emoji ? Color.white : Color.bgShowcase)
                                                .clipShape(Circle())
                                                .shadow(
                                                    color: selectedEmoji == emoji ? Color.textPrimary.opacity(0.1) : .clear,
                                                    radius: 5, x: 0, y: 5
                                                )
                                                .overlay(
                                                    Circle().stroke(Color.clayMint, lineWidth: selectedEmoji == emoji ? 4 : 0)
                                                )
                                        }
                                    }
                                }
                                .padding(10)
                            }
                        }
                        
                        // 2. Task Name
                        VStack(alignment: .leading) {
                            Text("任务名称")
                                .softFont(.headline)
                                .padding(.leading, 5)
                            
                            ClayTextField(placeholder: "譬如：洗香香...", text: $title)
                                .frame(height: 60)
                        }
                        
                        // 3. Points Slider
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("悬赏积分")
                                    .softFont(.headline)
                                Spacer()
                                Text("\(Int(points))")
                                    .softFont(.title2, weight: .black)
                                    .foregroundStyle(Color.clayVanilla.darker(by: 0.3))
                            }
                            
                            Slider(value: $points, in: 10...500, step: 10)
                                .tint(Color.clayMint)
                                .padding()
                                .background(Color.white.opacity(0.5)) // Slightly transparent background for recessed feel
                                .cornerRadius(20)
                                // Use innerShadow instead of clayEffect for "Recessed" look
                                .innerShadow(cornerRadius: 20, color: Color.gray.opacity(0.15))
                        }
                        
                        /*
                        // 4. Recurring Toggle (Temporarily disabled)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("每日任务")
                                    .softFont(.headline)
                                Text("每天都要做一次吗？")
                                    .softFont(.caption)
                                    .foregroundStyle(Color.textSecondary)
                            }
                            
                            Spacer()
                            
                            JellyToggle(isOn: $isRecurring)
                        }
                        .padding()
                        .clayEffect(color: .white, cornerRadius: 25)
                        */
                    }
                    .padding(20)
                }
                
                // 5. Submit Button
                SquishyButton(action: {
                    if !title.isEmpty {
                        store.addTask(title: title, icon: selectedEmoji, points: points, isRecurring: isRecurring)
                        
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        dismiss()
                    }
                }) {
                    Text("发布悬赏 ! 🚀")
                        .softFont(.title3, weight: .heavy)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .clayEffect(color: .clayPink, cornerRadius: 30) // Pink button
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
            }
            .padding()
        }
    }
}

#Preview {
    CreateView()
}
