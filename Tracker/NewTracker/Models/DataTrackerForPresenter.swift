
import UIKit

struct DataTrackerForPresenter {
    let name: String?
    let category: String?
    let color: UIColor?
    let emoji: Emoji?
    let schedule: Set<Schedule>?
    
    init(name: String? = nil, category: String? = nil, color: UIColor? = nil, emoji: Emoji? = nil, schedule: Set<Schedule>? = nil) {
        self.name = name
        self.category = category
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    func dataFilled() -> Bool {
        return name != nil && name != "" &&
            category != nil && category != "" &&
            color != nil &&
            emoji != nil &&
            schedule?.count ?? 0 > 0
    }
}
