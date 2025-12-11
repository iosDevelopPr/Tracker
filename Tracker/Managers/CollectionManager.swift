
import UIKit

final class CollectionManager: NSObject {
    private let collectionView: UICollectionView
    
    private let cellCount: Int = 2          // Колличество секций
    private let leftInset: CGFloat = 16     // Левый отступ
    private let rightInset: CGFloat = 16    // Правый отступ
    private let cellSpacing: CGFloat = 9    // Расстояние между секциями
    private let cellHeight: Int = 148       // Высота секции, ширина расчетная
    
    private let trackersManager = TrackersManager.shared
    private let picker: UIDatePicker
    
    private var categories: [TrackerCategory] = []

    init(collectionView: UICollectionView, picker: UIDatePicker) {
        self.collectionView = collectionView
        self.picker = picker
        
        super.init()
        updateCategories()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.identifier)
    }
    
    func updateCategories() {
        self.categories = trackersManager.getCategories(day: Schedule.dayOfWeek(date: picker.date))
    }
}

extension CollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
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
        return cellSpacing
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath
        ) as? TrackersCollectionViewCell else {
            fatalError("Could not dequeue a cell with identifier: \(TrackersCollectionViewCell.identifier)")
        }
        let tracker = self.categories[indexPath.section].trackers[indexPath.row]
        cell.configure(tracker: tracker, date: picker.date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SupplementaryView.identifier,
            for: indexPath
        ) as? SupplementaryView else {
            fatalError("Failed to dequeue SupplementaryView")
        }
        view.titleLabel.text = self.categories[indexPath.section].name
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.categories.count
    }
}
