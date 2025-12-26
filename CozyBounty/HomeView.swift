import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: BountyStore
    @State private var showCreateSheet = false
    
    var body: some View {
        ZStack {
            Color.bgShowcase.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - ☁️ Cloud Header
                HeaderView()
                    .padding(.bottom, -20) // Overlap slightly
                    .zIndex(1)
                
                // MARK: - 🎡 Task Playground (Masonry Grid)
                ScrollView {
                    // Empty State
                    if store.tasks.isEmpty {
                        VStack(spacing: 20) {
                            Text("🫧")
                                .font(.system(size: 80))
                            Text("这里空空如也\n去捏个新任务吧！")
                                .softFont(.headline)
                                .multilineTextAlignment(.center)
                                .opacity(0.5)
                        }
                        .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                            ForEach(store.tasks) { task in
                                TaskCard(task: task)
                                    .onTapGesture {
                                        // Complete Task
                                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                                        generator.impactOccurred()
                                        store.completeTask(task)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                        .padding(.bottom, 120) // Space for FAB
                    }
                }
            }
            
            // FAB (Floating Action Button)
            VStack {
                Spacer()
                HStack {
                    Spacer() // Move to right
                    
                    SquishyButton(action: {
                        showCreateSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 70, height: 70)
                            // Custom "Soft Black" Clay Effect
                            .background(Color.black)
                            .clipShape(Circle())
                            // Top-left highlight (subtle on black)
                            .shadow(color: .white.opacity(0.25), radius: 5, x: -3, y: -3)
                            // Bottom-right shadow (softened and diffused)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 8, y: 8)
                    }
                    .padding(.trailing, 30) // Side padding
                }
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            CreateView()
        }
    }
}

// MARK: - ☁️ Header Component
struct HeaderView: View {
    @EnvironmentObject var store: BountyStore
    @State private var showProfile = false
    
    // Animation States
    @State private var scalePiggy: CGFloat = 1.0
    // Stackable Rewards System
    struct RewardItem: Identifiable {
        let id = UUID()
        let amount: Int
    }
    @State private var activeRewards: [RewardItem] = []
    
    var body: some View {
        ZStack {
            // Simplified: No background cloud anymore
            
            HStack(alignment: .center) { // Center alignment for icon and text
                // Left: Shortened Title
                Text("任务包")
                    .softFont(.largeTitle, weight: .heavy)
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                // Right: Profile/Piggy Bank Entry
                Button(action: { showProfile = true }) {
                    // Use HStack for proper layout resizing instead of overlay offset
                    HStack(spacing: 8) {
                        // Points Text
                        Text("\(store.totalPoints)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(Color.clayVanilla.darker(by: 0.4))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8) // Shrink slightly if 999k+ hits edge
                            .layoutPriority(1)
                            // FLOATING REWARD POPUPS (Stackable)
                            .overlay(alignment: .topTrailing) {
                                ZStack {
                                    ForEach(activeRewards) { reward in
                                        FloatingRewardPopup(amount: reward.amount) {
                                            // Cleanup closure
                                            if let index = activeRewards.firstIndex(where: { $0.id == reward.id }) {
                                                activeRewards.remove(at: index)
                                            }
                                        }
                                    }
                                }
                            }
                        
                        ZStack {
                            // Piggy Icon
                            Circle()
                                .fill(Color.clayVanilla)
                                .frame(width: 55, height: 55)
                                .overlay(Text(store.userAvatar).font(.system(size: 30)))
                                .shadow(color: .clayVanilla.darker(by: 0.1), radius: 2, y: 2)
                                .scaleEffect(scalePiggy) // BOUNCE ANIMATION
                        }
                    }
                }
                // TRIGGER ANIMATION
                .onChange(of: store.rewardTrigger) { _ in
                    animateReward()
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 10) // Reduced top padding significantly
            .padding(.bottom, 10)
        }
        .frame(height: 140)
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
    
    func animateReward() {
        // 1. Bounce Piggy
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
            scalePiggy = 1.3
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3).delay(0.1)) {
            scalePiggy = 1.0
        }
        
        // 2. Add New Reward Popup
        let newReward = RewardItem(amount: store.lastReward)
        activeRewards.append(newReward)
    }
}

// Subview for individual firing animation
struct FloatingRewardPopup: View {
    let amount: Int
    let onComplete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Text("+\(amount)")
            .font(.system(size: 20, weight: .heavy, design: .rounded))
            .foregroundStyle(Color.clayMint.darker(by: 0.4))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 3)
            .fixedSize()
            .offset(y: offset - 30) // Start slightly above
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    offset = -80 // Float up higher
                    opacity = 0
                }
                
                // Cleanup after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onComplete()
                }
            }
    }
}

// MARK: - 🍪 Task Card Component
struct TaskCard: View {
    let task: BountyTask
    
    var body: some View {
        // ZStack to place avatar at bottom right
        ZStack(alignment: .bottomTrailing) {
            
            VStack(alignment: .leading, spacing: 5) { // Tighter spacing
                HStack {
                    Text(task.emoji)
                        .font(.system(size: 40)) // Larger Emoji
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                    
                    Spacer()
                    
                    Text("\(task.points)")
                        .softFont(.title3, weight: .black)
                        .foregroundStyle(Color.textPrimary.opacity(0.6))
                }
                
                Spacer() // Push title down slightly
                
                Text(task.title)
                    .softFont(.headline, weight: .bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(1, contentMode: .fit) // SQUARE CARD (1:1)
            .clayEffect(color: task.color, cornerRadius: 25)
            
            // Author Avatar Badge
            Text(task.authorAvatar)
                .font(.system(size: 16))
                .padding(6)
                .background(Color.white.opacity(0.6))
                .clipShape(Circle())
                .padding(10)
        }
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    HomeView()
        .environmentObject(BountyStore())
}
