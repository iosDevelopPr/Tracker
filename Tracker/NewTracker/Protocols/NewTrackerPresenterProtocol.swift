
import UIKit

protocol NewTrackerPresenterProtocol {
    var trackerForPresenter: DataTrackerForPresenter { get }
    
    func configure(view: NewTrackerViewControllerProtocol)
    
    func updateName(name: String?)
    func updateCategory(category: String?)
    func updateColor(color: UIColor?)
    func updateEmoji(emoji: Emoji?)
    func updateSchedule(schedule: Set<Schedule>?)
    
    func scheduleString() -> String
    func categoryString() -> String
    
    func saveTracker()
}
