
import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    } ()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    } ()
    
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
                
                if let schedule = tracker.schedule, let scheduleData = try? jsonEncoder.encode(schedule) {
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
                
                if let schedule = tracker.schedule, let scheduleData = try? jsonEncoder.encode(schedule) {
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
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
                
                let allTrackers = try context.fetch(request)

                let scheduleDay = Schedule.dayOfWeek(date: date)
                var categoryMap: [(categoryID: NSManagedObjectID, name: String, trackers: [Tracker])] = []

                var categoryDict: [NSManagedObjectID: (name: String, trackers: [Tracker])] = [:]

                for trackerCoreData in allTrackers {
                    guard let category = trackerCoreData.category,
                          let categoryName = category.name,
                          let scheduleData = trackerCoreData.schedule,
                          let schedule = try? jsonDecoder.decode(Set<Schedule>.self, from: scheduleData),
                          schedule.contains(scheduleDay) else { continue }

                    let tracker = getTracker(tracker: trackerCoreData)

                    categoryDict[category.objectID, default: (name: categoryName, trackers: [])].trackers.append(tracker)
                }

                categoryMap = categoryDict.map { (key, value) in
                    (categoryID: key, name: value.name, trackers: value.trackers)
                }

                return categoryMap
                    .sorted { $0.categoryID.uriRepresentation().absoluteString < $1.categoryID.uriRepresentation().absoluteString }
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
        let scheduleTracker = tracker.schedule ?? Data()
        var schedule: Set<Schedule>
        do {
            schedule = try jsonDecoder.decode(Set<Schedule>.self, from: scheduleTracker)
        } catch {
            schedule = []
        }

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
}
