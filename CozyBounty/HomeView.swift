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
                SquishyButton(action: {
                    showCreateSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 70, height: 70)
                        .clayEffect(color: .clayMint, cornerRadius: 35)
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
    
    var body: some View {
        ZStack {
            // Cloud Shape Background
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.05), radius: 10, x: 0, y: 10)
                .padding(.top, -50) // Extend up to safe area
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Cozy Bounty")
                        .softFont(.caption, weight: .bold)
                        .foregroundStyle(Color.textSecondary)
                    Text("任务游乐场")
                        .softFont(.title, weight: .heavy)
                        .foregroundStyle(Color.textPrimary)
                }
                Spacer()
                
                // Profile/Piggy Bank Entry
                Button(action: { showProfile = true }) {
                    HStack(spacing: 8) {
                        Text("\(store.totalPoints)")
                            .softFont(.caption, weight: .bold)
                            .foregroundStyle(Color.clayVanilla.darker(by: 0.3))
                        
                        Circle()
                            .fill(Color.clayVanilla)
                            .frame(width: 40, height: 40)
                            .overlay(Text("🐷").font(.title3))
                            .shadow(color: .clayVanilla.darker(by: 0.1), radius: 2, y: 2)
                    }
                    .padding(5)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 25)
        }
        .frame(height: 140)
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

// MARK: - 🍪 Task Card Component
struct TaskCard: View {
    let task: BountyTask
    
    var body: some View {
        // Just the view, interaction moved to parent for better control
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(task.emoji)
                    .font(.system(size: 32))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                
                Spacer()
                
                Text("\(task.points)")
                    .softFont(.title3, weight: .black)
                    .foregroundStyle(Color.textPrimary.opacity(0.6))
            }
            
            Text(task.title)
                .softFont(.headline, weight: .bold)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true) // Allow wrapping
            
            if task.isRecurring {
                Label("Daily", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        // Use the Clay Effect!
        .clayEffect(color: task.color, cornerRadius: 30)
        // Add a scale animation when appearing
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    HomeView()
        .environmentObject(BountyStore())
}
