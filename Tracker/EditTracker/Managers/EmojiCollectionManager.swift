
import UIKit

final class EmojiCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let presenter: EditTrackerPresenterProtocol
    
    private let cellHeight: Int = 52
    private let cellWidth: Int = 52
    private let cellSpacingSection = CGFloat(5)
    private let headerHeight: Double = 19

    private let sectionInsets: UIEdgeInsets = .init(top: 24, left: 18, bottom: 0, right: 19)
    
    private var selectedEmoji: Emoji?

    init(collectionView: UICollectionView, presenter: EditTrackerPresenterProtocol) {
        self.collectionView = collectionView
        self.presenter = presenter
        
        super.init()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .trackerWhite
        
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            EmojiSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiSupplementaryView.reuseIdentifier
        )
    }
    
    func setSelectedEmoji(emoji: Emoji) {
        selectedEmoji = emoji
        if let index = Emoji.allCases.firstIndex(of: emoji) {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
}

extension EmojiCollectionManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach {
            $0.contentView.backgroundColor = .trackerWhite
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .trackerGrayEmoji
        }
        
        presenter.updateEmoji(emoji: Emoji.allCases[indexPath.row])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .trackerWhite
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
            withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? EmojiCollectionViewCell else {
            assertionFailure("Failed to dequeue \(EmojiCollectionViewCell.reuseIdentifier)")
            return UICollectionViewCell()
        }
        
        if let selectedEmoji, let index = Emoji.allCases.firstIndex(of: selectedEmoji) {
            if indexPath.row == index {
                cell.contentView.backgroundColor = .trackerGrayEmoji
                self.selectedEmoji = nil
            }
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
            withReuseIdentifier: EmojiSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? EmojiSupplementaryView else {
            assertionFailure("Failed to dequeue \(EmojiSupplementaryView.reuseIdentifier)")
            return UICollectionReusableView()
        }
            
            view.titleLabel.text = Localization.emojiTitle
        return view
    }
}

extension EmojiCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
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
