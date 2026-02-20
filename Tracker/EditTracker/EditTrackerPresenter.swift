
import UIKit

final class EditTrackerPresenter: EditTrackerPresenterProtocol {
    private var view: EditTrackerViewControllerProtocol?
    
    private(set) var trackerForPresenter = DataTrackerForPresenter() {
        didSet {
            guard let view else { return }
            view.updateButtonCreate(enableButton: trackerForPresenter.dataFilled())
        }
    }
    
    func configure(view: EditTrackerViewControllerProtocol, tracker: Tracker?, category: String?) {
        self.view = view
        
        if let tracker {
            self.trackerForPresenter = DataTrackerForPresenter(
                id: tracker.id,
                name: tracker.name,
                category: category,
                color: tracker.color,
                emoji: tracker.emoji,
                schedule: tracker.schedule,
                isPinned: tracker.isPinned
            )
        }
    }

    func updateName(name: String?) {
        let newName = name == "" ? nil : name
        
        let newTracker = DataTrackerForPresenter(
            id: trackerForPresenter.id,
            name: newName,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule,
            isPinned: trackerForPresenter.isPinned
        )
        
        trackerForPresenter = newTracker
    }
    
    func updateCategory(category: String?) {
        view?.reloadButtonTable()
        
        let newCategory = category == "" ? nil : category
        
        let newTracker = DataTrackerForPresenter(
            id: trackerForPresenter.id,
            name: trackerForPresenter.name,
            category: newCategory,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule,
            isPinned: trackerForPresenter.isPinned
        )
        
        trackerForPresenter = newTracker
        
        if newCategory == nil {
            view?.updateViewMode()
        }
    }
    
    func updateEmoji(emoji: Emoji?) {
        let newTracker = DataTrackerForPresenter(
            id: trackerForPresenter.id,
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: emoji,
            schedule: trackerForPresenter.schedule,
            isPinned: trackerForPresenter.isPinned
        )
        
        trackerForPresenter = newTracker
    }
    
    func updateColor(color: UIColor?) {
        let newTracker = DataTrackerForPresenter(
            id: trackerForPresenter.id,
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: color,
            emoji: trackerForPresenter.emoji,
            schedule: trackerForPresenter.schedule,
            isPinned: trackerForPresenter.isPinned
        )
        
        trackerForPresenter = newTracker
    }
    
    func updateSchedule(schedule: Set<Schedule>?) {
        view?.reloadButtonTable()
        
        let newSchedule = schedule?.isEmpty == true ? nil : schedule
        
        let newTracker = DataTrackerForPresenter(
            id: trackerForPresenter.id,
            name: trackerForPresenter.name,
            category: trackerForPresenter.category,
            color: trackerForPresenter.color,
            emoji: trackerForPresenter.emoji,
            schedule: newSchedule,
            isPinned: trackerForPresenter.isPinned
        )
        
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
        if !trackerForPresenter.dataFilled() { return }
        
        guard let category = trackerForPresenter.category, !category.isEmpty else { return }
        let updateTracker: Bool = trackerForPresenter.id != nil
        
        guard let newTracker = newTracker() else { return }
        
        let trackerDataProvider = TrackerDataProvider()
        if updateTracker {
            try trackerDataProvider.updateTracker(tracker: newTracker, categoryName: category)
        } else {
            try trackerDataProvider.addTracker(tracker: newTracker, categoryName: category)
        }
    }
    
    private func newTracker() -> Tracker? {
        guard let name = trackerForPresenter.name,
              let color = trackerForPresenter.color,
              let emoji = trackerForPresenter.emoji,
              let schedule = trackerForPresenter.schedule
        else { return nil }
        
        let id = trackerForPresenter.id ?? UUID()
        
        let newTracker = Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isPinned: trackerForPresenter.isPinned)
        
        return newTracker
    }
    
    func recordCount() -> Int {
        guard let trackerID = trackerForPresenter.id else { return 0 }
        return RecordDataProvider(trackerID: trackerID, delegate: nil).recordCount
    }
    
    func trackerExists() -> Bool {
        guard let trackerID = trackerForPresenter.id else { return false }
        return TrackerDataProvider().trackerExists(id: trackerID)
    }
}
