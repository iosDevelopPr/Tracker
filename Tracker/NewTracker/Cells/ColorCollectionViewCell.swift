
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ColorCollectionViewCell"
    
    private let colorSquare: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    } ()
    
    var cellColor: UIColor? {
        didSet {
            colorSquare.backgroundColor = cellColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupUI() {
        contentView.addSubview(colorSquare)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.clear.cgColor

        NSLayoutConstraint.activate([
            colorSquare.widthAnchor.constraint(equalToConstant: 40),
            colorSquare.heightAnchor.constraint(equalToConstant: 40),
            colorSquare.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorSquare.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
