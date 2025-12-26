import Foundation
import SwiftUI

struct BountyTask: Identifiable {
    let id = UUID()
    var title: String
    var emoji: String
    var points: Int
    var isRecurring: Bool
    var color: Color
    var authorAvatar: String = "👤" // Default avatar
    var isCompleted: Bool = false
}

struct MockData {
    static let tasks = [
        BountyTask(title: "洗碗碗", emoji: "🍽️", points: 50, isRecurring: true, color: .clayVanilla, authorAvatar: "👨🏻"),
        BountyTask(title: "给猫铲屎", emoji: "🐈", points: 200, isRecurring: true, color: .clayMint, authorAvatar: "👩🏻"),
        BountyTask(title: "倒垃圾", emoji: "🗑️", points: 30, isRecurring: true, color: .clayPink, authorAvatar: "👦🏻"),
        BountyTask(title: "叠衣服", emoji: "👕", points: 100, isRecurring: false, color: .clayLavender, authorAvatar: "👨🏻"),
        BountyTask(title: "浇花", emoji: "🪴", points: 40, isRecurring: true, color: .clayBlue, authorAvatar: "👵🏻"),
        BountyTask(title: "清理书桌", emoji: "🧹", points: 150, isRecurring: false, color: .clayVanilla, authorAvatar: "👩🏻")
    ]
}
