
import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    var managedObjectContext: NSManagedObjectContext {
        return self.context
    }
    
    private init () {
        self.persistentContainer = NSPersistentContainer(name: "TrackerCoreData")
        self.persistentContainer.loadPersistentStores { (description, error) in }
        
        self.context = self.persistentContainer.newBackgroundContext()
    }
    
    deinit {
        self.saveContext()
        self.cleanDataStore()
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
