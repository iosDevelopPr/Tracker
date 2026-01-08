
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init () {
        persistentContainer = NSPersistentContainer(name: "TrackerCoreData")
        persistentContainer.loadPersistentStores { (description, error) in }
        
        context = persistentContainer.newBackgroundContext()
    }
    
    deinit {
        saveContext()
        cleanDataStore()
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return context
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
    
    private func cleanDataStore() {
        context.performAndWait {
            let coordinator = self.persistentContainer.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}
