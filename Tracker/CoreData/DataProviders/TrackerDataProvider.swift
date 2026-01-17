
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
        do {
            return try dataStore.getCategoriesWithTrackers(date: date)
        } catch {
            return []
        }
    }
    
    func addTracker(tracker: Tracker, categoryName: String) throws {
        try dataStore.addTracker(tracker: tracker, categoryName: categoryName)
    }
}

extension TrackerDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.DidUpdate()
    }
}
