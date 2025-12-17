
import UIKit

final class ColorCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let presenter: NewTrackerPresenterProtocol
    
    private let colorsCount: Int = 18
    private let cellHeight: Int = 52
    private let cellWidth: Int = 52
    private let cellSpacingSection = CGFloat(5)
    
    private let sectionInsets: UIEdgeInsets = .init(top: 24, left: 18, bottom: 0, right: 19)
    
    init(collectionView: UICollectionView, presenter: NewTrackerPresenterProtocol) {
        self.collectionView = collectionView
        self.presenter = presenter
        
        super.init()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )
        collectionView.register(
            ColorsSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ColorsSupplementaryView.identifier
        )
    }
}

extension ColorCollectionManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        colorsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath
        ) as? ColorCollectionViewCell else {
            fatalError("Failed to dequeue ColorCollectionViewCell")
        }
        
        cell.cellColor = UIColor.getUIColor(index: indexPath.row + 1)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ColorsSupplementaryView.identifier,
            for: indexPath
        ) as? ColorsSupplementaryView else {
            fatalError("Failed to dequeue \(ColorsSupplementaryView.identifier)")
        }
        
        view.titleLabel.text = "Цвет"
        return view
    }
}

extension ColorCollectionManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach { cell in
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            let color = UIColor.getUIColor(index: indexPath.row + 1)
            cell.contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        }
        presenter.updateColor(color: UIColor.getUIColor(index: indexPath.row + 1))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        presenter.updateColor(color: nil)
    }
}

extension ColorCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.frame.width, height: 19)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpacingSection
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }
}
