import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: BountyStore
    
    // Mock Data
    let collectedToys = ["🧸", "🚗", "🦖", "🚀", "🦄", "🎨"]
    
    var body: some View {
        ZStack {
            // 1. Clean Background (Cream)
            Color.bgShowcase.ignoresSafeArea()
            
            // 2. Decorative Background Blobs (Subtle)
            VStack {
                Circle()
                    .fill(Color.clayVanilla.opacity(0.4))
                    .frame(width: 400, height: 400)
                    .offset(x: -150, y: -200)
                    .blur(radius: 60)
                Spacer()
                Circle()
                    .fill(Color.clayMint.opacity(0.3))
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: 150)
                    .blur(radius: 50)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Avatar Header
                // No big shadow circle, just clean avatar layout
                VStack(spacing: 15) {
                    ZStack {
                        // Outer Ring
                        Circle()
                            .fill(Color.white)
                            .frame(width: 110, height: 110)
                            .clayEffect(color: .white, cornerRadius: 55)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(LinearGradient(colors: [.clayLavender, .clayPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 90, height: 90)
                    }
                    
                    Text("Cozy User")
                        .softFont(.title2, weight: .heavy)
                        .foregroundStyle(Color.textPrimary)
                }
                .padding(.top, 40)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 35) {
                        
                        // MARK: - 🏺 The Glass Jar (Points)
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.clayVanilla.darker(by: 0.2))
                                Text("MY SAVINGS")
                                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                                    .tracking(2)
                                    .foregroundStyle(Color.textSecondary)
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.clayVanilla.darker(by: 0.2))
                            }
                            
                            // Points Big Number
                            Text("\(store.totalPoints)")
                                .font(.system(size: 80, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.clayMint.darker(by: 0.2), .clayBlue.darker(by: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .shadow(color: .white, radius: 2, x: -2, y: -2)
                                .shadow(color: .clayMint.opacity(0.3), radius: 2, x: 2, y: 2)
                                .padding(.vertical, 20)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - 🧸 Toy Collection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("MY TOY BOX")
                                .font(.system(size: 14, weight: .heavy, design: .rounded))
                                .tracking(2)
                                .foregroundStyle(Color.textSecondary)
                                .padding(.leading, 30)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                                ForEach(collectedToys, id: \.self) { toy in
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 80, height: 80)
                                            .shadow(color: .black.opacity(0.03), radius: 5, y: 5)
                                        
                                        Text(toy)
                                            .font(.system(size: 45))
                                    }
                                }
                            }
                            .padding(.horizontal, 25)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.textSecondary)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
}
