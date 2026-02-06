
import UIKit

final class EditTrackerViewController: UIViewController {
    
    // MARK: - Elements UI
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let countDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let fieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    private let nameField = UITextField()
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.nameFieldMaxLengthLabel
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
        button.setTitle(Localization.cancelButton, for: .normal)
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
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .trackerForLightGray

        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private var emojiCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        return collection
    } ()
    
    private var colorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        return collection
    } ()

    // MARK: - Data and Managers
    private let buttonsIdentifiers = [Localization.categoryTitle, Localization.scheduleTitle]
    private let placeholderText = Localization.trackerPlaceholder
    private let numberSection: Int = 2
    private var isWarningHidden = true
    
    private var countDayHeightConstraint: NSLayoutConstraint?
    private var textFieldContainerHeightConstraint: NSLayoutConstraint?
    private var textFieldContainerTopConstraint: NSLayoutConstraint?
    
    private var emojiCollectionManager: EmojiCollectionManager
    private var colorCollectionManager: ColorCollectionManager

    private var nameFieldManager: NameFieldManager
    private let presenter: EditTrackerPresenterProtocol
    private var countRecords: Int = 0
    private let isNewTracker: Bool

    // MARK: - Initializer
    init(presenter: EditTrackerPresenterProtocol, tracker: Tracker?, category: String?) {
        self.presenter = presenter
        
        self.nameFieldManager = NameFieldManager(nameField: nameField,
            presenter: presenter, placeholder: placeholderText)
        self.emojiCollectionManager = EmojiCollectionManager(collectionView: emojiCollection,
            presenter: presenter)
        self.colorCollectionManager = ColorCollectionManager(collectionView: colorCollection,
            presenter: presenter)
        
        self.isNewTracker = tracker == nil
        
        super.init(nibName: nil, bundle: nil)
        
        self.nameFieldManager.addDelegate(delegate: self)
        self.presenter.configure(view: self, tracker: tracker, category: category)

        if let tracker {
            self.nameField.text = tracker.name
            self.emojiCollectionManager.setSelectedEmoji(emoji: tracker.emoji)
            self.colorCollectionManager.setSelectedColor(color: tracker.color)
            
            self.countRecords = self.presenter.recordCount()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizer()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .trackerWhite

        setupMainLabel()
        setupScrollVIew()
        setupCountDayLabel()
        setupNameFieldContainer()
        setupNameField()
        setupButtonsTable()
        setupEmojiCollection()
        setupColorCollection()
        setupCancelButton()
        setupCreateButton()
        
        setButtonDisable()
        
        presenter.updateName(name: nameField.text)
    }
    
    private func setupMainLabel() {
        titleLabel.text = isNewTracker ? Localization.newTrackerTitle : Localization.editTrackerTitle

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    private func setupScrollVIew() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCountDayLabel() {
        if isNewTracker || countRecords == 0 { return }
        
        countDayLabel.text = Helpers.countDays(countDays: countRecords)
        
        scrollView.addSubview(countDayLabel)
        
        countDayHeightConstraint = countDayLabel.heightAnchor.constraint(equalToConstant: 38)
        countDayHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            countDayLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            countDayLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            countDayLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNameFieldContainer() {
        scrollView.addSubview(fieldContainer)

        textFieldContainerHeightConstraint = fieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHeightConstraint?.isActive = true
        
        if isNewTracker || countRecords == 0 {
            textFieldContainerTopConstraint = fieldContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24)
            textFieldContainerTopConstraint?.isActive = true
        } else {
            textFieldContainerTopConstraint = fieldContainer.topAnchor.constraint(equalTo: countDayLabel.bottomAnchor, constant: 40)
            textFieldContainerTopConstraint?.isActive = true
        }
        
        NSLayoutConstraint.activate([
            fieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            fieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            fieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNameField() {
        nameField.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
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
        buttonTable.register(
            ButtonsTableViewCells.self,
            forCellReuseIdentifier: ButtonsTableViewCells.reuseIdentifier
        )
        scrollView.addSubview(buttonTable)
        
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupEmojiCollection() {
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiCollection)

        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: buttonTable.bottomAnchor, constant: 34),
            emojiCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 228)
        ])
    }
    
    private func setupColorCollection() {
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorCollection)

        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 34),
            colorCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 228)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        scrollView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 24),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupCreateButton() {
        let titleCreateButton = isNewTracker ? Localization.createButton : Localization.saveButton
        createButton.setTitle(titleCreateButton, for: .normal)

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
        try? presenter.saveTracker()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setButtonEnable() {
        createButton.backgroundColor = .trackerBackgroundBlack
        createButton.isEnabled = true
    }

    func setButtonDisable() {
        createButton.backgroundColor = .trackerForLightGray
        createButton.isEnabled = false
    }
}

extension EditTrackerViewController: NameFieldManagerDelegate {
    func showWarningLabel() {
        if isWarningHidden {
            textFieldContainerHeightConstraint?.constant = 113
            setupWarningLabel()
            UIView.animate(withDuration: 0) {
                self.scrollView.layoutIfNeeded()
            }
            isWarningHidden = false
        }
    }
    
    func hideWarningLabel() {
        if !isWarningHidden {
            textFieldContainerHeightConstraint?.constant = 75
            warningLabel.removeFromSuperview()
            isWarningHidden = true
        }
    }
}

extension EditTrackerViewController: EditTrackerViewControllerProtocol {
    func reloadButtonTable() {
        buttonTable.reloadData()
    }
    
    func updateButtonCreate(enableButton: Bool) {
        if enableButton {
            setButtonEnable()
        } else {
            setButtonDisable()
        }
    }
    
    func updateViewMode() {
        guard !presenter.trackerExists() else { return }
        
        if scrollView.subviews.contains(countDayLabel) {
            countDayLabel.isHidden = true
            countDayHeightConstraint?.constant = 0
            textFieldContainerTopConstraint?.constant = 0
            titleLabel.text = Localization.newTrackerTitle
        }
    }
}

extension EditTrackerViewController: UITableViewDelegate {
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
        case Localization.categoryTitle:
            createViewController = CategoryViewController(
                presenter: presenter,
                selectedCategory: presenter.trackerForPresenter.category)
        case Localization.scheduleTitle:
            createViewController = ScheduleViewController(presenter: presenter)
        default:
            return
        }
        
        createViewController.modalPresentationStyle = .pageSheet
        present(createViewController, animated: true)
    }
}

extension EditTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ButtonsTableViewCells.reuseIdentifier, for: indexPath
        ) as? ButtonsTableViewCells else {
            return UITableViewCell()
        }

        let identifier = buttonsIdentifiers[indexPath.row]
        var descriptionText: String = ""
        
        switch identifier {
        case Localization.categoryTitle:
            descriptionText = presenter.categoryString()
        case Localization.scheduleTitle:
            descriptionText = presenter.scheduleString()
        default:
            break
        }
        cell.configure(title: identifier, description: descriptionText)

        cell.selectionStyle = .none
        return cell
    }
}
