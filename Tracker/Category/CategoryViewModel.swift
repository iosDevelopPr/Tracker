
import UIKit

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    var categorySelected: Binding<TrackerCategory?>?
    var listCategoryEmpty: Binding<Bool>?
    var updateTableView: Binding<Void>?
    
    var lastSelectedCategory: String?
    
    private var categories: [TrackerCategory] = []
    private var categoryDataProvider: CategoryDataProvider
    
    init() {
        self.categoryDataProvider = CategoryDataProvider()
        self.categoryDataProvider.delegate = self
    }
    
    var numberOfSections: Int {
        return categories.count
    }
    
    func getCategory(indexPath: IndexPath) -> TrackerCategory {
        categories[indexPath.row]
    }
    
    func getCategories() {
        categories = categoryDataProvider.getCategories()
        listCategoryEmpty?(categories.isEmpty)
    }
    
    func categorySelected(indexPath: IndexPath) {
        categorySelected?(categories[indexPath.row])
    }
    
    func deleteCategory(name: String) {
        do {
            try categoryDataProvider.deleteCategory(name: name)
            if name == lastSelectedCategory {
                lastSelectedCategory = nil
                categorySelected?(nil)
            }
        } catch {}
    }
    
    func updateCategory(name: String, nameOld: String) {
        try? categoryDataProvider.updateCategory(name: name, nameOld: nameOld)
    }
}

extension CategoryViewModel: DataProviderDelegate {
    func didUpdate() {
        getCategories()
        updateTableView?(())
    }
}
