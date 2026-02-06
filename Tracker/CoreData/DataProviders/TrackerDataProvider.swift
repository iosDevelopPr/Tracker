
import Foundation
import CoreData

final class TrackerDataProvider: NSObject {
    weak var delegate: DataProviderDelegate?
    
    private let dataStore: TrackerStore = TrackerStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    } ()
    
    override init() {
        super.init()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print ("Failed to fetch: \(error)")
        }
    }

    func getCategoriesWithTrackers(date: Date) -> [TrackerCategory] {
        var categories = try? dataStore.getCategoriesWithTrackers(date: date)
        var pinnedTrackers: [Tracker] = []
        var unpinnedTrackers: [Tracker] = []

        categories = categories?.compactMap { category in
            unpinnedTrackers.removeAll()
            category.trackers.forEach { tracker in
                if tracker.isPinned {
                    pinnedTrackers.append(tracker)
                }
                else {
                    unpinnedTrackers.append(tracker)
                }
            }
            return unpinnedTrackers.isEmpty ? nil : TrackerCategory(
                name: category.name, trackers: unpinnedTrackers)
        }
        
        if !pinnedTrackers.isEmpty {
            categories?.insert(
                TrackerCategory(name: Localization.pinned, trackers: pinnedTrackers), at: 0)
        }
        
        return categories ?? []
    }
    
    func addTracker(tracker: Tracker, categoryName: String) throws {
        try dataStore.addTracker(tracker: tracker, categoryName: categoryName)
    }
    
    func updateTracker(tracker: Tracker, categoryName: String) throws {
        try dataStore.updateTracker(tracker: tracker, categoryName: categoryName)
    }

    func deleteTracker(tracker: Tracker) {
        try? dataStore.deleteTracker(tracker: tracker)
    }
    
    func togglePin(tracker: Tracker) {
        try? dataStore.togglePin(tracker: tracker)
    }
    
    func trackerExists(id: UUID) -> Bool {
        do {
            return try dataStore.trackerExists(id: id)
        } catch { return false }
    }

    func getCategoryForTracker(id: UUID) -> String? {
        return try? dataStore.getCategoryForTracker(id: id)
    }
}

extension TrackerDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
