
import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Elements UI
    private let plusButton: UIButton = {
        let plusImage: UIImage = .plus
        
        let button = UIButton()
        button.setImage(plusImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    } ()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.trackersTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let dizzyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dizzy
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let dizzyLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.trackerListPlaceholder
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Localization.searchPlaceholder
        searchBar.searchBarStyle = .minimal
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.leftViewMode = .always
            textField.backgroundColor = .trackerLightGray
        }
        
        searchBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    } ()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .trackerLightGray
        datePicker.tintColor = .trackerBackgroundBlack
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        datePicker.locale = Locale.current
        return datePicker
    } ()
    
    private let datePickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textAlignment = .center
        label.backgroundColor = .trackerLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    } ()
    
    private let badSearchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .badSearch
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let badSearchLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.badSearchPlaceholder
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private var trackerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        return collection
    } ()
    
    // MARK: - Properties
    private var trackersCollectionManager: TrackersCollectionManager?
    private var filterManager: FilterManager?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterManager = FilterManager()
        filterManager?.view = self

        setupNavigationBar()
        setupViewController()
        setupGestureRecognizer()
        
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsService.shared.logEvent(
            event: "open",
            screen: "Main",
            item: "screen"
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AnalyticsService.shared.logEvent(
            event: "close",
            screen: "Main",
            item: "screen"
        )
    }
    
    // MARK: - Actions
    @objc private func didTapPlusButton(_ sender: Any) {
        AnalyticsService.shared.logEvent(
            event: "click",
            screen: "Main",
            item: "add_track"
        )
        
        let editTrackerPresenter = EditTrackerPresenter()
        let editTrackerViewController = EditTrackerViewController(
            presenter: editTrackerPresenter, tracker: nil, category: nil)
        editTrackerViewController.modalPresentationStyle = .pageSheet
        present(editTrackerViewController, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        datePickerLabel.text = selectedDate.toShortDateString()
    }

    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViewController() {
        view.backgroundColor = .trackerWhite
        
        setupPlusButton()
        setupTrackerLabel()
        setupSearchBar()
        setupDizzyImage()
        setupDizzyLabel()
        setupDatePicker()
        setupTrackerCollection()
        setupBadSearch()
        
        updateUI()
    }
    
    private func setupPlusButton() {
        plusButton.addTarget(self, action: #selector(didTapPlusButton(_:)), for: .touchUpInside)
        view.addSubview(plusButton)

        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            
            plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6)
        ])
    }
    
    private func setupTrackerLabel() {
        view.addSubview(trackerLabel)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            trackerLabel.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: 10)
        ])
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: -1),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }

    private func setupDizzyImage() {
        view.addSubview(dizzyImage)
        
        NSLayoutConstraint.activate([
            dizzyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dizzyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDizzyLabel() {
        view.addSubview(dizzyLabel)
        
        NSLayoutConstraint.activate([
            dizzyLabel.topAnchor.constraint(equalTo: dizzyImage.bottomAnchor, constant: 8),
            dizzyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dizzyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupDatePicker() {
        view.addSubview(datePicker)
        view.addSubview(datePickerLabel)

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            datePickerLabel.widthAnchor.constraint(equalToConstant: 77),
            datePickerLabel.heightAnchor.constraint(equalToConstant: 34),
            datePickerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePickerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.leadingAnchor.constraint(equalTo: datePickerLabel.leadingAnchor, constant: 0)
        ])

        datePicker.date = Date.now
        dateChanged(datePicker)
    }
    
    private func setupTrackerCollection() {
        trackersCollectionManager = TrackersCollectionManager(
            collectionView: trackerCollection,
            picker: datePicker,
            delegate: self
        )
        
        view.addSubview(trackerCollection)

        NSLayoutConstraint.activate([
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBadSearch() {
        view.addSubview(badSearchImage)
        
        NSLayoutConstraint.activate([
            badSearchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            badSearchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    
        view.addSubview(badSearchLabel)
        
        NSLayoutConstraint.activate([
            badSearchLabel.topAnchor.constraint(equalTo: badSearchImage.bottomAnchor, constant: 8),
            badSearchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            badSearchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setCollectionHidden(hidden: Bool) {
        trackerCollection.isHidden = hidden
    }
    
    private func setDizzy(hidden: Bool) {
        dizzyImage.isHidden = hidden
        dizzyLabel.isHidden = hidden
    }

    private func setBadSearch(hidden: Bool) {
        badSearchImage.isHidden = hidden
        badSearchLabel.isHidden = hidden
    }
}

extension TrackersViewController: TrackersCollectionDelegate {
    func updateUI() {
        let hasTrackers = trackersCollectionManager?.hasTrackers ?? false
        let searchText = searchBar.text ?? ""

        if hasTrackers {
            filterManager?.showFilterButton()
        } else {
            filterManager?.hideFilterButton()
        }

        if hasTrackers {
            setCollectionHidden(hidden: false)
            setDizzy(hidden: true)
            setBadSearch(hidden: true)
        } else if searchText.isEmpty {
            setCollectionHidden(hidden: true)
            setDizzy(hidden: false)
            setBadSearch(hidden: true)
        } else {
            setCollectionHidden(hidden: true)
            setDizzy(hidden: true)
            setBadSearch(hidden: false)
        }
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let searchText = searchBar.text ?? ""
        trackersCollectionManager?.setSearchText(searchText: searchText)
        updateUI()
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        searchBar.searchTextField.text = ""
        
        trackersCollectionManager?.setSearchText(searchText: "")
        updateUI()
        
        return true
    }
}

extension TrackersViewController: FiltersViewProtocol {
    func setFilter(filter: FilterChoice) {
        if filter == .today {
            datePicker.date = Date.now
            dateChanged(datePicker)
        }
        if trackersCollectionManager?.getFilter() != filter {
            trackersCollectionManager?.setFilter(filter: filter)
        }
    }
    
    func getFilter() -> FilterChoice {
        return trackersCollectionManager?.getFilter() ?? .all
    }
}
