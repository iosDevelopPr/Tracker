
import UIKit

final class CategoryPageViewController: UIViewController {
    private let dizzyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .dizzy)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let textLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Привычки и события можно\nобъединить по смыслу"
        Label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        Label.textAlignment = .center
        Label.numberOfLines = 2
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    } ()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(resource: .trackerWhite)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(resource: .trackerBackgroundBlack)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    } ()
    
    private var trackerTableViewManager: TrackerTableViewManager?
    private let presenter: NewTrackerPresenterProtocol
    private var selectedCategory: String?
    
    init(presenter: NewTrackerPresenterProtocol, selectedCategory: String?) {
        self.presenter = presenter
        self.selectedCategory = selectedCategory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .trackerWhite)
        self.trackerTableViewManager = TrackerTableViewManager(
            tableView: tableView, delegate: self, selectedCategory: selectedCategory)
        
        setupUI()
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupDizzyImage()
        setupTextLabel()
        setupCreateButton()
        setupTableView()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupDizzyImage() {
        view.addSubview(dizzyImageView)
        
        NSLayoutConstraint.activate([
            dizzyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dizzyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTextLabel() {
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: dizzyImageView.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupCreateButton() {
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -20)
        ])
    }

    @objc private func createButtonTapped() {
        let createCategoryViewController = NewCategoryViewController(delegate: self)
        createCategoryViewController.modalPresentationStyle = .pageSheet
        present(createCategoryViewController, animated: true)
    }
}

extension CategoryPageViewController: CategoryPageViewControllerProtocol {
    func categorySelected(selectedCategory: TrackerCategory) {
        presenter.updateCategory(category: selectedCategory.name)
        dismiss(animated: true)
    }
    
    func listCategoryNotEmpty(isEmpty: Bool) {
        dizzyImageView.isHidden = isEmpty
        textLabel.isHidden = isEmpty
        tableView.isHidden = !isEmpty
    }
    
    func categoryAdded() {
        trackerTableViewManager?.getCategories()
        tableView.reloadData()
    }
}
