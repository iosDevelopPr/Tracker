
import UIKit

final class ColorCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let presenter: EditTrackerPresenterProtocol
    
    private let colorsCount: Int = 18
    private let cellHeight: Int = 52
    private let cellWidth: Int = 52
    private let cellSpacingSection = CGFloat(5)
    private let headerHeight: Double = 19
    
    private let sectionInsets: UIEdgeInsets = .init(top: 24, left: 18, bottom: 0, right: 19)
    
    private var selectedColor: UIColor?
    
    init(collectionView: UICollectionView, presenter: EditTrackerPresenterProtocol) {
        self.collectionView = collectionView
        self.presenter = presenter
        
        super.init()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ColorsSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ColorsSupplementaryView.reuseIdentifier
        )
    }
    
    func setSelectedColor(color: UIColor) {
        selectedColor = color
        if let index = UIColor.getIndex(color: color) {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
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
            withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? ColorCollectionViewCell else {
            assertionFailure("Failed to dequeue \(ColorCollectionViewCell.reuseIdentifier)")
            return UICollectionViewCell()
        }
        
        if let selectedColor, let index = UIColor.getIndex(color: selectedColor) {
            if indexPath.row == index {
                cell.contentView.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
                self.selectedColor = nil
            }
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
            withReuseIdentifier: ColorsSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? ColorsSupplementaryView else {
            assertionFailure("Failed to dequeue \(ColorsSupplementaryView.reuseIdentifier)")
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = Localization.colorTitle
        return view
    }
}

extension ColorCollectionManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach {
            $0.contentView.layer.borderColor = UIColor.clear.cgColor
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
        .init(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        cellSpacingSection
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }
}
