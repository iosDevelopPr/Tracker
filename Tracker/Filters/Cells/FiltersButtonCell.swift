
import UIKit

final class FiltersButtonCell: UITableViewCell {
    static let reuseIdentifier: String = "FiltersButtonCell"
    
    // MARK: - UI Elements
    private let cellTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
    
    func configure(title: String, isSelected: Bool) {
        cellTextLabel.text = title
        rightImageView.isHidden = !isSelected
    }
}
