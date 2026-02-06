
import UIKit

protocol EditTrackerPresenterProtocol {
    var trackerForPresenter: DataTrackerForPresenter { get }
    
    func configure(view: EditTrackerViewControllerProtocol, tracker: Tracker?, category: String?)
    
    func updateName(name: String?)
    func updateCategory(category: String?)
    func updateColor(color: UIColor?)
    func updateEmoji(emoji: Emoji?)
    func updateSchedule(schedule: Set<Schedule>?)
    
    func scheduleString() -> String
    func categoryString() -> String

    func saveTracker() throws
    
    func recordCount() -> Int
    func trackerExists() -> Bool
}
