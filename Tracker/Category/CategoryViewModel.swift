
import UIKit

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    var categorySelected: Binding<TrackerCategory>?
    var listCategoryEmpty: Binding<Bool>?
    var updateTableView: Binding<Void>?
    
    var selectedCategory: String?
    
    private(set) var categories: [TrackerCategory] = []
    private var categoryDataProvider: CategoryDataProvider?
    
    init() {
        self.categoryDataProvider = CategoryDataProvider(delegate: self)
    }
    
    func getCategories() {
        categories = categoryDataProvider?.getCategories() ?? []
        listCategoryEmpty?(categories.isEmpty)
    }
    
    func categorySelected(indexPath: IndexPath) {
        categorySelected?(categories[indexPath.row])
    }
}

extension CategoryViewModel: DataProviderDelegate {
    func DidUpdate() {
        getCategories()
        updateTableView?(())
    }
}
