
import UIKit

final class NewTrackerPresenter: NewTrackerPresenterProtocol {
    private var view: NewTrackerViewControllerProtocol?
    
    private(set) var tracker: Tracker
    private var category: TrackerCategory
    
    init() {
        self.category = TrackersManager.shared.category(index: 0) ?? TrackerCategory(name: "Общая категория привычек", trackers: [])
        
        let randomNumber = Int.random(in: 1...18)
        let colorName = "TrackerColor\(randomNumber)"
        let color = UIColor(resource: .init(name: colorName, bundle: .main))
        
        self.tracker = Tracker(id: UUID(), name: "", color: color, schedule: [])
    }
    
    func configure(view: NewTrackerViewControllerProtocol) {
        self.view = view
    }
    
    func updateName(name: String) {
        self.tracker = Tracker(id: self.tracker.id, name: name, color: self.tracker.color, schedule: self.tracker.schedule)
        view?.updateButtonCreate()
    }
    
    func updateSchedule(schedule: Set<Schedule>) {
        self.tracker = Tracker(id: self.tracker.id, name: self.tracker.name, color: self.tracker.color, schedule: schedule)
        view?.reloadButtonTable()
        view?.updateButtonCreate()
    }
    
    func scheduleString() -> String {
        let schedule = self.tracker.schedule ?? []
        return Schedule.scheduleString(schedule: schedule)
    }
    
    func categoryString() -> String {
        return self.category.name
    }
    
    func dataFilled() -> Bool {
        return self.tracker.name != "" && self.tracker.schedule != nil && self.tracker.schedule?.count ?? 0 > 0
    }
    
    func createTracker() {
        let trackerManager = TrackersManager.shared
        
        if trackerManager.category(categoryName: self.category.name) == nil {
            trackerManager.addCategory(category: self.category)
        }
        trackerManager.addTracker(categoryName: self.category.name, tracker: self.tracker)
    }
}
