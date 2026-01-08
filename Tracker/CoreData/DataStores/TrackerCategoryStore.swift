
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
    func getCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.resultType = .managedObjectResultType
        let categoriesCoreData = try? context.fetch(request)
        
        let trackerStore = TrackerStore()
        
        var categories: [TrackerCategory] = []
        var trackers: [Tracker] = []
        categoriesCoreData?.forEach { category in
            trackers = []
            category.trackers?.forEach { trackerCoreData in
                trackers.append(trackerStore.getTracker(tracker: trackerCoreData as! TrackerCoreData))
            }
            categories.append(TrackerCategory(name: category.name ?? "", trackers: trackers))
        }
        
        return categories
    }
    
    func addCategory(name: String) {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.resultType = .countResultType
        
        let result = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        guard result.finalResult?[0] as! Int == 0 else { return }
        
        let category = CategoryCoreData(context: context)
        category.name = name
        
        do { try context.save() } catch {}
    }
    
    func removeCategory(name: String) {
        
    }
}
