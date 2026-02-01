
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
    
    func deleteCategory(name: String) throws {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            if let categoryCoreData = try context.fetch(request).first {
                context.delete(categoryCoreData)
                try context.save()
            }
        } catch { }
    }
    
    func updateCategory(name: String, nameOld: String) throws {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", nameOld)
        
        do {
            if let categoryCoreData = try context.fetch(request).first {
                categoryCoreData.name = name
                try context.save()
            }
        } catch { }
    }
}
