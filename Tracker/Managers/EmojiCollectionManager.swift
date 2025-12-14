
import UIKit

final class EmojiCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let presenter: NewTrackerPresenterProtocol
    
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
        collectionView.register(EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(EmojiSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiSupplementaryView.identifier
        )
    }
}

extension EmojiCollectionManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach {
            $0.contentView.backgroundColor = .clear
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(resource: .trackerLightGray)
        }
        
        presenter.updateEmoji(emoji: Emoji.allCases[indexPath.row])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
        
        presenter.updateEmoji(emoji: nil)
    }
}

extension EmojiCollectionManager: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        Emoji.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCollectionViewCell.identifier,
            for: indexPath
        ) as? EmojiCollectionViewCell else {
            fatalError("Failed to dequeue \(EmojiCollectionViewCell.identifier)")
        }
        
        cell.configure(with: Emoji.allCases[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EmojiSupplementaryView.identifier,
            for: indexPath
        ) as? EmojiSupplementaryView else {
            fatalError("Failed to dequeue \(EmojiSupplementaryView.identifier)")
        }
            
        view.titleLabel.text = "Emoji"
        return view
    }
}

extension EmojiCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 19)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 0, right: 19)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 52, height: 52)
    }
}
