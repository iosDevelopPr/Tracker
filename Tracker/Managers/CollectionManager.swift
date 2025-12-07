
import UIKit

final class CollectionManager: NSObject {
    private let collectionView: UICollectionView
    
    private let cellCount: Int = 2
    private let leftInset: CGFloat = 16
    private let rightInset: CGFloat = 16
    private let cellSpacing: CGFloat = 9
    private let cellHeight: Int = 148

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
    }
}

extension CollectionManager: UICollectionViewDelegateFlowLayout {
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
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellSpacing
    }
}

extension CollectionManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CollectionManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath
        ) as? TrackersCollectionViewCell else {
            fatalError("Could not dequeue a cell with identifier: \("TrackersCollectionViewCell")")
        }
        //cell.configure()
        return cell
    }
}
