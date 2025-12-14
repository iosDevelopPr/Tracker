
import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "EmojiCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    } ()

    // MARK: - Properties
    private var emojiBackgroundColor: UIColor = .clear {
        didSet {
            emojiLabel.backgroundColor = emojiBackgroundColor
        }
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Configuration
    func configure(with emoji: String, backgroundColor: UIColor = .clear) {
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 31)
        emojiBackgroundColor = backgroundColor
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

}
