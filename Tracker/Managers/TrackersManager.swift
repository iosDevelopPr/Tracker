
import UIKit

final class TrackersManager {
    static let shared: TrackersManager = TrackersManager()
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    private let queue = DispatchQueue(label: "trackersManagerQueue", attributes: .concurrent)
    
    private init() {}

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
            if let index = self.categories.firstIndex(where: { $0.name == categoryName }) {
                var trackers = self.categories[index].trackers
                trackers.append(tracker)
                let newCategory = TrackerCategory(name: categoryName, trackers: trackers)
                self.categories[index] = newCategory
            }
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
            return self.categories
        }
    }

    func addCategory(categoryName: String) {
        queue.async(flags: .barrier) {
            guard self.category(categoryName: categoryName) != nil else {
                let category = TrackerCategory(name: categoryName, trackers: [])
                self.categories.append(category)
                return
            }
        }
    }

    func addCategory(category: TrackerCategory) {
        queue.async(flags: .barrier) {
            self.categories.append(category)
        }
    }

    // MARK: - records
    func countRecords(id: UUID) -> Int {
        return completedTrackers.filter { $0.id == id }.count
    }

    func hasRecord(id: UUID, date: Date) -> Bool {
        return completedTrackers.contains{ $0.id == id &&
            Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func changeRecord(id: UUID, date: Date) {
        if hasRecord(id: id, date: date) {
            self.removeRecord(id: id, date: date)
        } else {
            self.addRecord(record: TrackerRecord(id: id, date: date))
        }
    }

    func addRecord(record: TrackerRecord) {
        self.completedTrackers.insert(record)
    }

    func removeRecords(id: UUID) {
        self.completedTrackers = self.completedTrackers.filter { $0.id != id }
    }

    func removeRecord(id: UUID, date: Date) {
        let setForRemoval = self.completedTrackers.filter { $0.id == id &&
            Calendar.current.isDate($0.date, inSameDayAs: date) }
        guard let elementForRemoval = setForRemoval.first else { return }
        self.completedTrackers.remove(elementForRemoval)
    }
}
