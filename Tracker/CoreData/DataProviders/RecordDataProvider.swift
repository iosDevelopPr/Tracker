
import Foundation
import CoreData

final class RecordDataProvider: NSObject {
    private weak var delegate: RecordDataProviderDelegate?
    
    private let trackerID: UUID
    private let dataStore: TrackerRecordStore = TrackerRecordStore()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<RecordCoreData> = {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataManager.shared.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        return controller
    } ()
    
    init(trackerID: UUID, delegate: RecordDataProviderDelegate) {
        self.trackerID = trackerID
        self.delegate = delegate
        
        super.init()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch records: \(error)")
        }
    }
    
    var recordCount: Int {
        return dataStore.countRecords(id: trackerID)
    }
    
    func hasRecord(date: Date) -> Bool {
        return dataStore.hasRecord(id: trackerID, date: date)
    }
    
    func toggleRecord(date: Date) {
        let record = TrackerRecord(id: trackerID, date: date)
        dataStore.toggleRecord(record: record)
    }
    
    func clearDelegate() {
        delegate = nil
    }
}

extension RecordDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordsDidUpdate(id: trackerID)
    }
}
