
import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TrackersCollectionViewCell"
    
    // MARK: - Elements UI
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
        
        //label.text = "Новая привычка..."
        return label
    } ()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let executionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = UIColor(resource: .trackerBackgroundBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //label.text = "5 дней"
        return label
    } ()
    
    private let executionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(resource: .trackerBlue)
        return button
    } ()
    
    // MARK: - Properties
    private let trackerManager = TrackersManager.shared
    private var tracker: Tracker?
    private var date: Date?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - setupUI
    func configure(tracker: Tracker, date: Date) {
        self.tracker = tracker
        self.date = date
        
        self.trackerNameLabel.text = tracker.name
        self.cardView.backgroundColor = tracker.color
        self.executionButton.backgroundColor = tracker.color
        
        setupUI()
    }
    
    private func setupUI() {
        setupContainerView()
        setupCardView()
        setupEmojiLabel()
        setupTrackerNameLabel()
        setupFooterView()
        setupRecordLabel()
        setupRecordButton()
        
        setExecutionLabel()
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
        //cardView.backgroundColor = UIColor(resource: .trackerBlue)
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
        footerView.addSubview(executionLabel)
        
        NSLayoutConstraint.activate([
            executionLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            executionLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            executionLabel.widthAnchor.constraint(equalToConstant: 100),
            executionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupRecordButton() {
        executionButton.addTarget(self, action: #selector(executionButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(executionButton)
        
        NSLayoutConstraint.activate([
            executionButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            executionButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12),
            executionButton.widthAnchor.constraint(equalToConstant: 34),
            executionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        setExecutionButton()
    }
    
    // MARK: - Action
    @objc private func executionButtonTapped() {
        setCountExecutions()
        setExecutionButton()
        setExecutionLabel()
    }
    
    // MARK: - additional methods
    private func setExecutionButton() {
        guard let id = tracker?.id, let date else { return }
        if trackerManager.hasRecord(id: id, date: date) {
            executionButton.backgroundColor = executionButton.backgroundColor?.withAlphaComponent(0.5)
            executionButton.setImage(UIImage(resource: .done), for: .normal)
        }
        else {
            executionButton.backgroundColor = executionButton.backgroundColor?.withAlphaComponent(1)
            executionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            executionButton.tintColor = UIColor(resource: .trackerWhite)
        }
    }
    
    private func setCountExecutions() {
        guard let id = tracker?.id, let date, date <= Date() else { return }
        trackerManager.changeRecord(id: id, date: date)
    }

    private func setExecutionLabel() {
        guard let id = tracker?.id else { return }
        let countExecutions = trackerManager.countRecords(id: id)
        executionLabel.text = "\(countExecutions) дней"
    }
}
