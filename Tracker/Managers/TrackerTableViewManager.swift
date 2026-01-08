
import UIKit

final class TrackerTableViewManager: NSObject {
    
    private let tableView: UITableView
    private let trackersManager: TrackersManager = .shared
    private var trackerCategoryList: [TrackerCategory] = []
    private var delegate: CategoryPageViewControllerProtocol
    private var selectedCategory: String?
    
    init(tableView: UITableView, delegate: CategoryPageViewControllerProtocol, selectedCategory: String?) {
        self.tableView = tableView
        self.delegate = delegate
        self.selectedCategory = selectedCategory

        super.init()
        getCategories()
        setupTableView()
    }
    
    func getCategories() {
        trackerCategoryList = trackersManager.getCategories()
        delegate.listCategoryNotEmpty(isEmpty: !trackerCategoryList.isEmpty)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
}

extension TrackerTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = trackerCategoryList[indexPath.row]
        delegate.categorySelected(selectedCategory: selectedCategory)
    }
}

extension TrackerTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let category = trackerCategoryList[indexPath.row]
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == trackerCategoryList.count - 1
        let isSelected = self.selectedCategory == category.name
        
        cell.configure(text: category.name, isSelected: isSelected, isFirst: isFirst, isLast: isLast)
        cell.selectionStyle = .none
        
        return cell
    }
}
