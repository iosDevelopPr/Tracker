
import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TrackersCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(resource: .trackerWhite).withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "🌟"
        return label
    } ()
    
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(resource: .trackerWhite)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.text = "Новая привычка, и еще привычка, и еще н"
        return label
    } ()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let recordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(resource: .trackerBackgroundBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "5 дней"
        return label
    } ()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .trackerBlue)
        return button
    } ()
    
    private var completed: Bool = false
    private var countRecords: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupContainerView()
        setupCardView()
        setupEmojiLabel()
        setupTrackerNameLabel()
        setupFooterView()
        setupRecordLabel()
        setupRecordButton()
        setLabelState()
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCardView() {
        cardView.backgroundColor = UIColor(resource: .trackerBlue)
        containerView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupEmojiLabel() {
        cardView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12)
        ])
    }
    
    private func setupTrackerNameLabel() {
        cardView.addSubview(trackerNameLabel)
        
        NSLayoutConstraint.activate([
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupFooterView() {
        containerView.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupRecordLabel() {
        footerView.addSubview(recordLabel)
        
        NSLayoutConstraint.activate([
            recordLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            recordLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            recordLabel.widthAnchor.constraint(equalToConstant: 100),
            recordLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupRecordButton() {
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            recordButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12),
            recordButton.widthAnchor.constraint(equalToConstant: 34),
            recordButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        setButtonStyle()
    }
    
    @objc private func recordButtonTapped() {
        completed = !completed
        setButtonStyle()
        setCount()
        setLabelState()
    }
    
    private func setButtonStyle() {
        if completed {
            recordButton.backgroundColor = recordButton.backgroundColor?.withAlphaComponent(0.5)
            recordButton.setImage(UIImage(resource: .done), for: .normal)
        }
        else {
            recordButton.backgroundColor = recordButton.backgroundColor?.withAlphaComponent(1)
            recordButton.setImage(UIImage(systemName: "plus"), for: .normal)
            recordButton.tintColor = UIColor(resource: .trackerWhite)
        }
    }
    
    private func setCount() {
        if completed {
            countRecords = countRecords + 1
        } else {
            countRecords = countRecords - 1
        }
    }

    private func setLabelState() {
        recordLabel.text = "\(countRecords) дней"
    }
}
