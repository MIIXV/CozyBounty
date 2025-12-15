import SwiftUI
import Combine

class BountyStore: ObservableObject {
    @Published var tasks: [BountyTask] = []
    @Published var totalPoints: Int = 1250 // Initial points (mock)
    
    init() {
        // Load initial mock data
        self.tasks = MockData.tasks
    }
    
    // MARK: - Actions
    
    func addTask(title: String, icon: String, points: Double, isRecurring: Bool) {
        let colors: [Color] = [.clayVanilla, .clayMint, .clayPink, .clayLavender, .clayBlue]
        let randomColor = colors.randomElement() ?? .clayVanilla
        
        let newTask = BountyTask(
            title: title,
            emoji: icon,
            points: Int(points),
            isRecurring: isRecurring,
            color: randomColor
        )
        
        // Add to top of list
        withAnimation(.spring()) {
            tasks.insert(newTask, at: 0)
        }
    }
    
    func completeTask(_ task: BountyTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // 1. Add points
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                totalPoints += task.points
            }
            
            // 2. Remove task (if not recurring) or mark done
            // For fun, let's just remove it with a delay to let animation play
            withAnimation(.easeOut(duration: 0.3)) {
                tasks.remove(at: index)
            }
        }
    }
}
