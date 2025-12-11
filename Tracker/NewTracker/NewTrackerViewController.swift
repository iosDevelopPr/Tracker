
import UIKit

final class NewTrackerViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let fieldContainer = UIView()
    private let nameField = UITextField()
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.backgroundColor = .trackerWhite
        label.textColor = .trackerBorderRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let buttonTable: UITableView = {
        let button = UITableView()
        button.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.trackerBorderRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.borderColor = UIColor(resource: .trackerBorderRed).cgColor
        button.layer.borderWidth = 1
        
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(resource: .trackerForLightGray)

        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()

    private let buttonsIdentifiers = ["Категория", "Расписание"]
    private var textFieldContainerHeightConstraint: NSLayoutConstraint!
    private var isWarningHidden = true
    
    private var nameFieldManager: NameFieldManager
    var delegate: NewTrackerViewControllerDelegate?
    private let presenter: NewTrackerPresenterProtocol

    // MARK: - Initializer
    init(presenter: NewTrackerPresenterProtocol) {
        self.presenter = presenter
        self.nameFieldManager = NameFieldManager(nameField: nameField, presenter: presenter)
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.configure(view: self)
        self.nameFieldManager.addDelegate(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestureRecognizer()
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .trackerWhite)
        
        setupScrollVIew()
        setupMainLabel()
        setupNameFieldContainer()
        setupNameField()
        setupButtonsTable()
        setupCancelButton()
        setupCreateButton()
        
        updateButtonCreate()
    }
    
    private func setupScrollVIew() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupMainLabel() {
        scrollView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setupNameFieldContainer() {
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(fieldContainer)

        textFieldContainerHeightConstraint = fieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            fieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            fieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            fieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            fieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNameField() {
        fieldContainer.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            nameField.heightAnchor.constraint(equalToConstant: 75),
            nameField.centerXAnchor.constraint(equalTo: fieldContainer.centerXAnchor),
            nameField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            nameField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor)
        ])
    }

    private func setupWarningLabel() {
        fieldContainer.addSubview(warningLabel)

        NSLayoutConstraint.activate([
            warningLabel.heightAnchor.constraint(equalToConstant: 22),
            warningLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor)
        ])
    }

    private func setupButtonsTable() {
        buttonTable.delegate = self
        buttonTable.dataSource = self
        buttonTable.register(ButtonsTableViewCells.self, forCellReuseIdentifier: "ButtonsTableViewCells")
        scrollView.addSubview(buttonTable)
        
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        scrollView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            //cancelButton.topAnchor.constraint(equalTo: buttonTable.bottomAnchor, constant: 24),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupCreateButton() {
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)

        scrollView.addSubview(createButton)

        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonPressed() {
        presenter.createTracker()
        delegate?.updateMainView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateButtonCreate() {
        if presenter.dataFilled() {
            setButtonEnable()
        } else {
            setButtonDisable()
        }
    }
    
    func setButtonEnable() {
        createButton.backgroundColor = UIColor(resource: .trackerBackgroundBlack)
        createButton.isEnabled = true
    }

    func setButtonDisable() {
        createButton.backgroundColor = UIColor(resource: .trackerForLightGray)
        createButton.isEnabled = false
    }
}

extension NewTrackerViewController: NameFieldManagerDelegate {
    func showWarningLabel() {
        if isWarningHidden {
            textFieldContainerHeightConstraint.constant = 113
            setupWarningLabel()
            UIView.animate(withDuration: 0) {
                self.scrollView.layoutIfNeeded()
            }
            isWarningHidden = false
        }
    }
    
    func hideWarningLabel() {
        if !isWarningHidden {
            textFieldContainerHeightConstraint.constant = 75
            warningLabel.removeFromSuperview()
            isWarningHidden = true
        }
    }
}

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = buttonsIdentifiers[indexPath.row]
        var createViewController: UIViewController

        switch selectedOption {
        case "Категория":
            createViewController = CategoryPageViewController()
        case "Расписание":
            createViewController = SchedulePageViewController(presenter: presenter)
        default:
            return
        }
        
        createViewController.modalPresentationStyle = .pageSheet
        present(createViewController, animated: true)
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ButtonsTableViewCells", for: indexPath
        ) as? ButtonsTableViewCells else {
            return UITableViewCell()
        }

        let identifier = buttonsIdentifiers[indexPath.row]
        var descriptionText: String = ""
        
        switch identifier {
        case "Категория":
            descriptionText = presenter.categoryString()
        case "Расписание":
            descriptionText = presenter.scheduleString()
        default:
            break
        }
        cell.configure(title: identifier, description: descriptionText)

        cell.selectionStyle = .none
        return cell
    }
}

extension NewTrackerViewController: NewTrackerViewControllerProtocol {
    func reloadButtonTable() {
        buttonTable.reloadData()
    }
}
