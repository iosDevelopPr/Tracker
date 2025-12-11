
import UIKit

final class ButtonsTableViewCells: UITableViewCell {
    private let labelsContainer = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .trackerBackgroundBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(resource: .trackerForLightGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let imageRightView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.image = UIImage(resource: .chevron)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupUI() {
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(titleLabel)
        labelsContainer.addSubview(descriptionLabel)
        
        contentView.addSubview(labelsContainer)

        contentView.addSubview(imageRightView)
        contentView.backgroundColor = UIColor(resource: .trackerLightGray)
        
        NSLayoutConstraint.activate([
            labelsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsContainer.trailingAnchor.constraint(equalTo: imageRightView.leadingAnchor, constant: -1),
            
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            descriptionLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),
            
            imageRightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageRightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageRightView.widthAnchor.constraint(equalToConstant: 24),
            imageRightView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
