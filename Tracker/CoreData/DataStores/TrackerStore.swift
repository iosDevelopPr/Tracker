
import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
    private func performSync<T>(_ action: (NSManagedObjectContext) -> Result<T, Error>) throws -> T {
        let context = self.context
        var result: Result<T, Error>!
        context.performAndWait {
            result = action(context)
        }
        return try result.get()
    }
    
    func addTracker(tracker: Tracker, categoryName: String) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "name == %@", categoryName)
                
                guard let categoryCoreData = try context.fetch(request).first else { return }
                
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = tracker.id
                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color.toHexString()
                trackerCoreData.emoji = tracker.emoji.rawValue
                
                if let schedule = tracker.schedule {
                    let scheduleData = schedule.map { $0.getNameInt() }.joined(separator: ", ")
                    trackerCoreData.schedule = scheduleData
                } else {
                    trackerCoreData.schedule = nil
                }
                
                categoryCoreData.addToTrackers(trackerCoreData)
                try context.save()
            }
        }
    }
    
    func deleteTracker(tracker: Tracker) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
                
                do {
                    if let trackerCoreData = try context.fetch(request).first {
                        context.delete(trackerCoreData)
                        try context.save()
                    }
                } catch { }
            }
        }
    }
    
    func updateTracker(tracker: Tracker, categoryName: String) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
                
                guard let trackerCoreData = try context.fetch(request).first else {
                    return
                }

                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color.toHexString()
                trackerCoreData.emoji = tracker.emoji.rawValue
                
                if let schedule = tracker.schedule {
                    let scheduleData = schedule.map { $0.getNameInt() }.joined(separator: ", ")
                    trackerCoreData.schedule = scheduleData
                } else {
                    trackerCoreData.schedule = nil
                }
                
                if trackerCoreData.category?.name != categoryName {
                    let requestCategory: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
                    requestCategory.predicate = NSPredicate(format: "name == %@", categoryName)
                    
                    guard let categoryCoreData = try context.fetch(requestCategory).first else {
                        return
                    }
                    
                    trackerCoreData.willChangeValue(forKey: "category")
                    trackerCoreData.category = categoryCoreData
                }

                try context.save()
            }
        }
    }
    
    func togglePin(tracker: Tracker) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
                
                guard let trackerCoreData = try context.fetch(request).first else {
                    return
                }
                
                trackerCoreData.isPinned.toggle()
                try context.save()
            }
        }
    }
    
    func getCategoriesWithTrackers(date: Date) throws -> [TrackerCategory] {
        return try performSync { context in
            Result {
                let scheduleDay = Schedule.dayOfWeek(date: date).getNameInt()
                
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "schedule CONTAINS %@", scheduleDay as CVarArg)
                
                var categoryDictionary: [String: [Tracker]] = [:]
                
                let allTrackers = try context.fetch(request)
                for trackerCoreData in allTrackers {
                    guard let category = trackerCoreData.category,
                          let categoryName = category.name
                    else { continue }
                    
                    let tracker = getTracker(tracker: trackerCoreData)
                    
                    if categoryDictionary[categoryName] == nil {
                        categoryDictionary[categoryName] = []
                    }
                    categoryDictionary[categoryName]?.append(tracker)
                }
                
                return categoryDictionary.map { (key, value) in
                    (name: key, trackers: value)
                }
                .sorted { $0.name < $1.name }
                .map { category in
                    TrackerCategory(
                        name: category.name,
                        trackers: category.trackers.sorted { $0.name < $1.name }
                    )
                }
            }
        }
    }
    
    private func getTracker(tracker: TrackerCoreData) -> Tracker {
        let scheduleTracker = tracker.schedule ?? ""
        let schedule =
            Set(
                scheduleTracker.split(separator: ",")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                .filter { (1...7).contains($0) }
                .sorted { $0 < $1 }
                .compactMap { Schedule.getSchedule(day: $0) }
            )

        let newTracker: Tracker = Tracker(
            id: tracker.id ?? UUID(),
            name: tracker.name ?? "",
            color: UIColor(hex: tracker.color ?? "#000000"),
            emoji: Emoji(rawValue: tracker.emoji ?? "😀") ?? .angryFace,
            schedule: schedule,
            isPinned: tracker.isPinned
        )
        
        return newTracker
    }
    
    func getCategoryForTracker(id: UUID) throws -> String? {
        return try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                guard let trackerCoreData = try context.fetch(request).first else {
                    return nil
                }
                
                return trackerCoreData.category?.name
            }
        }
    }
    
    func trackerExists(id: UUID) throws -> Bool {
        return try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                return try !context.fetch(request).isEmpty
            }
        }
    }
}
