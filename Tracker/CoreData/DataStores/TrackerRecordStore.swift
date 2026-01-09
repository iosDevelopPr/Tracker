
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
//    func getRecords() -> Set<TrackerRecord> {
//        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
//        
//        do {
//            let records: [RecordCoreData] = try self.context.fetch(request)
//            
//            return Set(records.map(\.toTrackerRecord))
//        } catch {
//            return []
//        }
//    }
    
    func toggleRecord(record: TrackerRecord) {
        if hasRecord(id: record.id, date: record.date) {
            removeRecord(id: record.id, date: record.date)
        } else {
            addRecode(record: record)
        }
    }
    
    private func addRecode(record: TrackerRecord) {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", record.id as CVarArg, record.date.stripTime() as CVarArg)
        request.fetchLimit = 1
        
        var count: Int = 0
        do {
            count = try context.count(for: request)
        } catch {
            count = 0
        }
        
        if count == 0 {
            let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", record.id as CVarArg)
            
            do {
                if let tracker = try context.fetch(request).first {
                    let newRecord = RecordCoreData(context: context)
                    newRecord.date = record.date.stripTime()
                    newRecord.tracker = tracker
                    
                    try context.save()
                }
            } catch {}
        }
    }
    
    func hasRecord(id: UUID, date: Date) -> Bool {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", id as CVarArg, date.stripTime() as CVarArg)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    private func removeRecord(id: UUID, date: Date) {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", id as CVarArg, date.stripTime() as CVarArg)
        
        do {
            let recordsToDelete = try context.fetch(request)
            if recordsToDelete.isEmpty {
                return
            }
            
            for record in recordsToDelete {
                context.delete(record)
            }
            
            try context.save()
        } catch { }
    }
    
    func countRecords(id: UUID) -> Int {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", id as CVarArg)
        request.resultType = .countResultType
        
        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
}
