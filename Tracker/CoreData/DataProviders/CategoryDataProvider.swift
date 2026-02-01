
import Foundation
import CoreData

final class CategoryDataProvider: NSObject {
    
    private let dataStore: TrackerCategoryStore = TrackerCategoryStore()
    weak var delegate: DataProviderDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CategoryCoreData> = {
        let fetchRequest: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
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
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func addCategory(name: String) throws {
        try dataStore.addCategory(name: name)
    }
    
    func deleteCategory(name: String) throws {
        try dataStore.deleteCategory(name: name)
    }
    
    func updateCategory(name: String, nameOld: String) throws {
        try dataStore.updateCategory(name: name, nameOld: nameOld)
    }
    
    func getCategories() -> [TrackerCategory] {
        let categoriesCoreData: [CategoryCoreData] = fetchedResultsController.fetchedObjects ?? []
        var categories: [TrackerCategory] = []
        
        categoriesCoreData.forEach { categoryCoreData in
            categories.append(TrackerCategory(name: categoryCoreData.name ?? "", trackers: []))
        }
        categories.sort { $0.name < $1.name }
        
        return categories
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
