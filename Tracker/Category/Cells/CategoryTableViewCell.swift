
import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "CategoryTableViewCell"
    
    // MARK: - Elements UI
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "Tracker"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .trackerCheckmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let leftIdent: CGFloat = 16
    private let rightIdent: CGFloat = 41
    private let topIdent: CGFloat = 27
    private let bottomIdent: CGFloat = 26

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .trackerLightGray
        
        contentView.insertSubview(cellTextLabel, at: 0)
        contentView.addSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            cellTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topIdent),
            cellTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftIdent),
            cellTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -rightIdent),
            cellTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomIdent)
        ])
        NSLayoutConstraint.activate([
            rightImageView.heightAnchor.constraint(equalToConstant: 14),
            rightImageView.widthAnchor.constraint(equalToConstant: 14),
            rightImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        rightImageView.isHidden = true
    }

    func configure(text: String, isSelected: Bool, isFirst: Bool, isLast: Bool) {
        cellTextLabel.text = text
        rightImageView.isHidden = !isSelected
        
        setupCornerRadius(isFirst: isFirst, isLast: isLast)
    }

    private func setupCornerRadius(isFirst: Bool, isLast: Bool) {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        if isFirst && isLast {
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirst {
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            contentView.layer.cornerRadius = 0
        }
    }
}
