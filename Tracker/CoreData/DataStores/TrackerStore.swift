
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
    
    func addTracker(tracker: Tracker, categoryName: String) {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", categoryName)

        guard let categoryCoreData = try? context.fetch(request).first else { return }

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
        
        CoreDataManager.shared.saveContext()
    }
    
    func removeTracker(tracker: Tracker) {
        
    }
    
    func getTracker(tracker: TrackerCoreData) -> Tracker {
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
            schedule: schedule
        )
        
        return newTracker
    }
    
    func getTrackerCoreData(tracker: Tracker) -> TrackerCoreData {
        let schedule = tracker.schedule
        var scheduleTracker: Data
        do {
            scheduleTracker = try jsonEncoder.encode(schedule)
        } catch {
            scheduleTracker = Data()
        }
        
        let newTracker: TrackerCoreData = TrackerCoreData(context: self.context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.color = tracker.color.toHexString()
        newTracker.emoji = tracker.emoji.rawValue
        newTracker.schedule = scheduleTracker
        
        return newTracker
    }
}
