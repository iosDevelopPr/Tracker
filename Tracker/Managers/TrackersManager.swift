
import UIKit

final class TrackersManager {
    static let shared: TrackersManager = TrackersManager()
    
    private var categories: [TrackerCategory] = []
    private let queue = DispatchQueue(label: "trackersManagerQueue", attributes: .concurrent)
    
    private init() {
        self.getCategoryStore()
    }

    // MARK: - trackers
    func hasTrackers(day: Schedule) -> Bool {
        queue.sync {
            return categories.contains { category in
                category.trackers.contains { tracker in
                    tracker.schedule?.contains(day) ?? false
                }
            }
        }
    }
    
    func addTracker(categoryName: String, tracker: Tracker) {
        queue.async(flags: .barrier) {
            if self.category(categoryName: categoryName) == nil {
                // Предполагается, что категория существует, но если это не так - создаем!
                self.categories.append(TrackerCategory(name: categoryName, trackers: []))
                
                let categoryStore = TrackerCategoryStore()
                categoryStore.addCategory(name: categoryName)
            }
            
            guard let index = self.categories
                .firstIndex(where: { $0.name == categoryName }) else { return }
            
            var trackers = self.categories[index].trackers
            if let indexTracker = trackers.firstIndex(where: { $0.id == tracker.id }) {
                trackers[indexTracker] = tracker
            } else {
                trackers.append(tracker)
            }
            
            let newCategory = TrackerCategory(name: categoryName, trackers: trackers)
            self.categories[index] = newCategory
            
            let trackerStore = TrackerStore()
            trackerStore.addTracker(tracker: tracker, categoryName: categoryName)
        }
    }

    // MARK: - categories
    func category(categoryName: String) -> TrackerCategory? {
        if let index = self.categories.firstIndex(where: { $0.name == categoryName }) {
            return categories[index]
        } else { return nil }
    }

    func getCategories(day: Schedule) -> [TrackerCategory] {
        queue.sync {
            return self.categories.compactMap { category in
                let trackersFilter = category.trackers.filter { tracker in
                    guard let schedule = tracker.schedule else { return false }
                    return schedule.contains(day)
                }
                return trackersFilter.isEmpty ? nil : TrackerCategory(
                    name: category.name, trackers: trackersFilter)
            }
        }
    }

    func getCategories() -> [TrackerCategory] {
        queue.sync {
            self.getCategoryStore()
            return self.categories
        }
    }
    
    private func getCategoryStore() {
        let trackerCategoryStore = TrackerCategoryStore()
        self.categories = trackerCategoryStore.getCategories()
    }

    func addCategory(categoryName: String) {
        queue.async(flags: .barrier) {
            guard self.category(categoryName: categoryName) != nil else {
                let category = TrackerCategory(name: categoryName, trackers: [])
                self.categories.append(category)
                
                let trackerCategoryStore = TrackerCategoryStore()
                trackerCategoryStore.addCategory(name: categoryName)
                
                return
            }
        }
    }

    func addCategory(category: TrackerCategory) {
        queue.async(flags: .barrier) {
            self.categories.append(category)
            
            let trackerCategoryStore = TrackerCategoryStore()
            trackerCategoryStore.addCategory(name: category.name)
        }
    }

    // MARK: - records
    func countRecords(id: UUID) -> Int {
        let trackerRecordStore = TrackerRecordStore()
        return trackerRecordStore.countRecords(id: id)
    }

    func hasRecord(id: UUID, date: Date) -> Bool {
        let trackerRecordStore = TrackerRecordStore()
        return trackerRecordStore.hasRecord(id: id, date: date)
    }
    
    func changeRecord(id: UUID, date: Date) {
        let trackerRecordStore = TrackerRecordStore()
        trackerRecordStore.toggleRecord(record: TrackerRecord(id: id, date: date))
    }
}
