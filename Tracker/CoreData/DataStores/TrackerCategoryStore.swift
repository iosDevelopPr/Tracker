
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
    func addCategory(name: String) throws {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        if try context.fetch(request).isEmpty {
            let category = CategoryCoreData(context: context)
            category.name = name
            
            try context.save()
        }
    }
}
