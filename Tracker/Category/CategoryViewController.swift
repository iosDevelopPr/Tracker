import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Elements UI
    private let dizzyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dizzy
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.categoryTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let textLabel: UILabel = {
        let Label = UILabel()
        Label.text = Localization.categoryListPlaceholder
        Label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        Label.textAlignment = .center
        Label.numberOfLines = 2
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    } ()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .trackerWhite
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trackerForLightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.addCategoryButton, for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .trackerBackgroundBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    } ()
    
    private let presenter: EditTrackerPresenterProtocol
    private var selectedCategory: String?
    private var trackerTableViewManager: TrackerTableViewManager?
    
    init(presenter: EditTrackerPresenterProtocol, selectedCategory: String?) {
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
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .trackerWhite
        
        setupTitleLabel()
        setupDizzyImage()
        setupTextLabel()
        setupCreateButton()
        setupTableView()
   }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 49)
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
        
        let viewModel = CategoryViewModel()
        viewModel.listCategoryEmpty = { [weak self] isEmpty in
            //DispatchQueue.main.async {
                self?.listCategoryEmpty(isEmpty: isEmpty)
            //}
        }
        viewModel.categorySelected = { [weak self] selectedCategory in
            //DispatchQueue.main.async {
                self?.categorySelected(selectedCategory: selectedCategory)
            //}
        }
        
        trackerTableViewManager = TrackerTableViewManager(
            tableView: tableView,
            selectedCategory: selectedCategory,
            viewModel: viewModel
        )
        
        trackerTableViewManager?.viewPresenter = { [weak self] viewForPresent in
            self?.present(viewForPresent, animated: true)
        }
    }

    @objc private func createButtonTapped() {
        let createCategoryViewController = EditCategoryViewController(nameCategory: nil)
        createCategoryViewController.modalPresentationStyle = .pageSheet
        present(createCategoryViewController, animated: true)
    }
    
    func categorySelected(selectedCategory: TrackerCategory?) {
        let selectedName = selectedCategory?.name
        presenter.updateCategory(category: selectedName)
        if selectedName != nil {
            dismiss(animated: true)
        }
    }
    
    func listCategoryEmpty(isEmpty: Bool) {
        dizzyImageView.isHidden = !isEmpty
        textLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}
