
import UIKit

final class TrackerTableViewManager: NSObject {
    
    private let tableView: UITableView
    private let viewModel: CategoryViewModel
    
    private let hightCell: CGFloat = 75
    
    init(tableView: UITableView, selectedCategory: String?, viewModel: CategoryViewModel) {
        self.tableView = tableView
        
        self.viewModel = viewModel
        self.viewModel.selectedCategory = selectedCategory

        super.init()
        
        self.viewModel.updateTableView = { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateTableView()
            }
        }
        
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
        viewModel.getCategories()
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }
}

extension TrackerTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        hightCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categorySelected(indexPath: indexPath)
    }
}

extension TrackerTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]

        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.categories.count - 1
        let isSelected = viewModel.selectedCategory == category.name
        
        cell.configure(text: category.name, isSelected: isSelected, isFirst: isFirst, isLast: isLast)
        cell.selectionStyle = .none
        
        return cell
    }
}
