import UIKit

final class TrackersViewController: UIViewController {
    private let plusButton: UIButton = {
        let plusImage = UIImage(resource: .plus)
        
        let button = UIButton()
        button.setImage(plusImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    } ()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let dizzyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .dizzy)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let dizzyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    } ()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = UIColor(resource: .trackerLightGray)
        datePicker.tintColor = UIColor(resource: .trackerBackgroundBlack)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    } ()
    
    private let datePickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textAlignment = .center
        label.backgroundColor = UIColor(resource: .trackerLightGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    } ()
    
    private var trackerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        return collection
    } ()
    
    // MARK: - Properties
    private var collectionManager: CollectionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupViewController()
    }

    // MARK: - Actions
    @objc private func didTapPlusButton(_ sender: Any) {
        let newTrackerViewController = NewTrackerViewController(presenter: NewTrackerPresenter())
        newTrackerViewController.delegate = self
        newTrackerViewController.modalPresentationStyle = .pageSheet
        present(newTrackerViewController, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        datePickerLabel.text = selectedDate.toShortDateString()
        
        collectionManager?.updateCategories()
        updateUI()
    }
    
    // MARK: -
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViewController() {
        view.backgroundColor = UIColor(resource: .trackerWhite)
        
        setupPlusButton()
        setupTrackerLabel()
        setupSearchBar()
        setupDizzyImage()
        setupDizzyLabel()
        setupDatePicker()
        setupTrackerCollection()
        
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
            dizzyImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)    // TODO
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
        collectionManager = CollectionManager(collectionView: trackerCollection, picker: datePicker)
        
        view.addSubview(trackerCollection)

        NSLayoutConstraint.activate([
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateUI() {
        let day = Schedule.dayOfWeek(date: datePicker.date)
        let hasTrackers = TrackersManager.shared.hasTrackers(day: day)
        setCollectionHidden(hidden: !hasTrackers)
    }
    
    private func setCollectionHidden(hidden: Bool) {
        trackerCollection.isHidden = hidden
        dizzyImage.isHidden = !hidden
        dizzyLabel.isHidden = !hidden
        trackerCollection.reloadData()
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegate {
    func updateMainView() {
        collectionManager?.updateCategories()
        updateUI()
    }
}
