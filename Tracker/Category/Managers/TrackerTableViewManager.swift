
import UIKit

final class TrackerTableViewManager: NSObject {
    
    private let tableView: UITableView
    private var categories: [TrackerCategory] = []
    private var delegate: CategoryViewControllerProtocol?
    private var selectedCategory: String?
    
    private var categoryDataProvider: CategoryDataProvider?
    
    private let hightCell: CGFloat = 75
    
    init(tableView: UITableView, selectedCategory: String?, delegate: CategoryViewControllerProtocol) {
        self.tableView = tableView
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        
        super.init()
        
        self.categoryDataProvider = CategoryDataProvider(delegate: self)
        
        setupTableView()
        reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
    }
    
    private func reloadData() {
        categories = categoryDataProvider?.getCategories() ?? []
        delegate?.listCategoryEmpty(isEmpty: categories.isEmpty)
    }
}

extension TrackerTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hightCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        delegate?.categorySelected(selectedCategory: selectedCategory)
    }
}

extension TrackerTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == categories.count - 1
        let isSelected = selectedCategory == category.name
        
        cell.configure(text: category.name, isSelected: isSelected, isFirst: isFirst, isLast: isLast)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension TrackerTableViewManager: DataProviderDelegate {
    func DidUpdate() {
        DispatchQueue.main.async {
            self.reloadData()
            self.tableView.reloadData()
        }
    }
}
