
import UIKit

final class NewTrackerPresenter: NewTrackerPresenterProtocol {
    private var view: NewTrackerViewControllerProtocol?
    
    private(set) var trackerForPresenter = DataTrackerForPresenter() {
        didSet {
            guard let view else { return }
            view.updateButtonCreate(enableButton: trackerForPresenter.dataFilled())
        }
    }
    
    func configure(view: NewTrackerViewControllerProtocol) {
        self.view = view
    }
    
    func updateName(name: String?) {
        let newName = name == "" ? nil : name
        
        let newTracker = DataTrackerForPresenter(
            name: newName,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule)
        
        trackerForPresenter = newTracker
    }
    
    func updateCategory(category: String?) {
        view?.reloadButtonTable()
        
        let newCategory = category == "" ? nil : category
        
        let newTracker = DataTrackerForPresenter(
            name: trackerForPresenter.name,
            category: newCategory,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule)
        
        trackerForPresenter = newTracker
    }
    
    func updateEmoji(emoji: Emoji?) {
        let newTracker = DataTrackerForPresenter(
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: emoji,
            schedule: trackerForPresenter.schedule)
        
        trackerForPresenter = newTracker
    }
    
    func updateColor(color: UIColor?) {
        let newTracker = DataTrackerForPresenter(
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule)
        
        trackerForPresenter = newTracker
    }
    
    func updateSchedule(schedule: Set<Schedule>?) {
        view?.reloadButtonTable()
        
        let newSchedule = schedule?.isEmpty == true ? nil : schedule
        
        let newTracker = DataTrackerForPresenter(
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: newSchedule)
        
        trackerForPresenter = newTracker
    }
    
    func scheduleString() -> String {
        let schedule = trackerForPresenter.schedule ?? []
        return Schedule.scheduleString(schedule: schedule)
    }
    
    func categoryString() -> String {
        return trackerForPresenter.category ?? ""
    }
    
    func saveTracker() throws {
        if trackerForPresenter.dataFilled() {
            guard let category = trackerForPresenter.category, !category.isEmpty else { return }
            
            let categoryDataProvider = CategoryDataProvider(delegate: nil)
            try categoryDataProvider.addCategory(name: category)
            
            guard let newTracker = newTracker() else { return }
            
            let trackerDataProvider = TrackerDataProvider()
            try trackerDataProvider.addTracker(tracker: newTracker, categoryName: category)
        }
    }
    
    private func newTracker() -> Tracker? {
        guard let name = trackerForPresenter.name,
              let color = trackerForPresenter.color,
              let emoji = trackerForPresenter.emoji,
              let schedule = trackerForPresenter.schedule
        else { return nil }
        
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule)
        
        return newTracker
    }
}
