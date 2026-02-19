
import UIKit

final class TrackerTableViewManager: NSObject {
    
    private let tableView: UITableView
    private let viewModel: CategoryViewModel
    
    private let hightCell: CGFloat = 75
    
    var viewPresenter: Binding<UIViewController>?
    
    init(tableView: UITableView, selectedCategory: String?, viewModel: CategoryViewModel) {
        self.tableView = tableView
        
        self.viewModel = viewModel
        self.viewModel.lastSelectedCategory = selectedCategory

        super.init()
        
        self.viewModel.updateTableView = { [weak self] _ in
            //DispatchQueue.main.async {
                self?.updateTableView()
            //}
        }
        
        self.setupTableView()
        self.reloadData()
    }
    
    private func setupTableView() {
        tableView.separatorColor = .trackerForLightGray
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
    
    private func showDeleteConfirmation(name: String) {
        let alert = UIAlertController(
            title: nil,
            message: Localization.deleteConfirmation,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: Localization.delete,
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.deleteCategory(name: name)
        }
        
        let cancelAction = UIAlertAction(
            title: Localization.cancelButton,
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        viewPresenter?(alert)
    }

}

extension TrackerTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        hightCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categorySelected(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

extension TrackerTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let category = viewModel.getCategory(indexPath: indexPath)

        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.numberOfSections - 1
        let isSelected = viewModel.lastSelectedCategory == category.name
        
        cell.configure(text: category.name, isSelected: isSelected, isFirst: isFirst, isLast: isLast)
        cell.selectionStyle = .none
        
        cell.editCategory = { [weak self] _ in
            let createCategoryViewController = EditCategoryViewController(nameCategory: category.name)
            createCategoryViewController.modalPresentationStyle = .pageSheet
            
            self?.viewPresenter?(createCategoryViewController)
        }
        
        cell.deleteCategory = { [weak self] _ in
            self?.showDeleteConfirmation(name: category.name)
        }
        
        return cell
    }
}
