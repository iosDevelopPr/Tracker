
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
    func getCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        
        let trackerStore = TrackerStore()
        var categories: [TrackerCategory] = []
        var trackers: [Tracker] = []
        
        do {
            let categoriesCoreData = try context.fetch(request)
            categoriesCoreData.forEach { category in
                trackers = []
                category.trackers?.forEach { trackerCoreData in
                    if let trackerCoreData = trackerCoreData as? TrackerCoreData {
                        trackers.append(trackerStore.getTracker(tracker: trackerCoreData))
                    }
                }
                categories.append(TrackerCategory(name: category.name ?? "", trackers: trackers))
                
            }
        } catch {}
        
        return categories
    }
    
    func addCategory(name: String) {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if try context.fetch(request).first == nil {
                let category = CategoryCoreData(context: context)
                category.name = name
                
                do { try context.save() } catch {}
            }
        } catch {}
    }
    
    func removeCategory(name: String) {
        
    }
}
