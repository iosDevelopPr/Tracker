
import UIKit

final class TrackersCollectionManager: NSObject {

    // MARK: - Properties
    private let collectionView: UICollectionView
    
    private let cellCount: Int = 2
    private let leftInset: CGFloat = 16
    private let rightInset: CGFloat = 16
    private let cellSpacing: CGFloat = 9
    private let cellHeight: Int = 148
    private let heightCategory: CGFloat = 54

    private let picker: UIDatePicker
    private let delegate: TrackersCollectionDelegate
    
    private var trackerDataProvider: TrackerDataProvider
    private var categoryDataProvider: CategoryDataProvider
    
    private var categories: [TrackerCategory] = []
    
    // MARK: - Initializer
    init(collectionView: UICollectionView, picker: UIDatePicker, delegate: TrackersCollectionDelegate) {
        self.collectionView = collectionView
        self.picker = picker
        self.delegate = delegate

        self.trackerDataProvider = TrackerDataProvider()
        self.categoryDataProvider = CategoryDataProvider()

        super.init()
        
        self.trackerDataProvider.delegate = self
        self.categoryDataProvider.delegate = self

        configurePicker()
        configureCollectionView()
        
        updateDate(date: picker.date)
    }

    // MARK: - Configuration
    private func configurePicker() {
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            TrackersCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            TrackersSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackersSupplementaryView.reuseIdentifier
        )
    }

    private func updateDate(date: Date) {
        categories = trackerDataProvider.getCategoriesWithTrackers(date: date)
        collectionView.reloadData()
        delegate.updateUI()
    }
    
    func hasTrackers(day: Schedule) -> Bool {
        return categories.contains { category in
            category.trackers.contains { tracker in
                tracker.schedule?.contains(day) ?? false
            }
        }
    }
    
    private func showDeleteConfirmation(tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: Localization.deleteConfirmation,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: Localization.delete,
            style: .destructive
        ) { [weak self] _ in
            self?.trackerDataProvider.deleteTracker(tracker: tracker)
        }
        
        let cancelAction = UIAlertAction(
            title: Localization.cancelButton,
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        delegate.present(alert, animated: true)
    }
    
    private func editTracker(tracker: Tracker, category: String?) {
        let editTrackerPresenter = EditTrackerPresenter()
        let editTrackerViewController = EditTrackerViewController(
            presenter: editTrackerPresenter, tracker: tracker, category: category)
        editTrackerViewController.modalPresentationStyle = .pageSheet
        delegate.present(editTrackerViewController, animated: true)
    }

    // MARK: - Actions
    @objc private func dateChanged(_ sender: UIDatePicker) {
        updateDate(date: sender.date)
    }
}

extension TrackersCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.frame.width, height: heightCategory)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthCollection = collectionView.frame.width
        let withCells = widthCollection - leftInset - rightInset - cellSpacing
        return CGSize(width: Int(withCells) / cellCount, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        cellSpacing
    }
}

extension TrackersCollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackersCollectionViewCell else {
            assertionFailure("Could not dequeue a cell with identifier: \(TrackersCollectionViewCell.reuseIdentifier)")
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        let category = trackerDataProvider.getCategoryForTracker(id: tracker.id)
        
        cell.configure(tracker: tracker, date: picker.date)
        
        cell.pinToggleTracker = { [weak self] _ in
            self?.trackerDataProvider.togglePin(tracker: tracker)
        }
        cell.editTracker = { [weak self] _ in
            self?.editTracker(tracker: tracker, category: category)
        }
        cell.deleteTracker = { [weak self] _ in
            self?.showDeleteConfirmation(tracker: tracker)
        }

        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackersSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? TrackersSupplementaryView else {
            assertionFailure("Could not dequeue a supplementary view with identifier: \(TrackersSupplementaryView.reuseIdentifier)")
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = categories[indexPath.section].name
        return view
    }
}

extension TrackersCollectionManager: DataProviderDelegate {
    func didUpdate() {
        //DispatchQueue.main.async {
            self.updateDate(date: self.picker.date)
        //}
    }
}
