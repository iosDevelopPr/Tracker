
import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TrackersCollectionViewCell"
    
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
        label.backgroundColor = .trackerWhite.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    } ()
    
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = .trackerWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    } ()
    
    private let pinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pin
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        label.textColor = .trackerBackgroundBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let executionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    // MARK: - Properties
    private var tracker: Tracker?
    private var date: Date?
    private var recordDataProvider: RecordDataProvider?
    
    var editTracker: Binding<Void>?
    var pinToggleTracker: Binding<Void>?
    var deleteTracker: Binding<Void>?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Configuration
    func configure(tracker: Tracker, date: Date) {
        self.tracker = tracker
        self.date = date
        
        self.recordDataProvider?.clearDelegate()
        self.recordDataProvider = RecordDataProvider(trackerID: tracker.id, delegate: self)
        
        setupData()
        setExecutionLabel()
        setExecutionButton()
        setPinImage()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        tracker = nil
        date = nil
        
        recordDataProvider?.clearDelegate()
        recordDataProvider = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupContainerView()
        setupCardView()
        setupEmojiLabel()
        setupTrackerNameLabel()
        setupFooterView()
        setupRecordLabel()
        setupRecordButton()
        
        setupContextMenu()
        setupPinIcon()
    }
    
    private func setupData() {
        guard let tracker else { return }
        
        self.trackerNameLabel.text = tracker.name
        self.cardView.backgroundColor = tracker.color
        self.executionButton.backgroundColor = tracker.color
        self.emojiLabel.text = tracker.emoji.rawValue
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
    
    private func setupPinIcon() {
        cardView.addSubview(pinImage)
        
        NSLayoutConstraint.activate([
            pinImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            pinImage.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImage.widthAnchor.constraint(equalToConstant: 8),
            pinImage.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupContextMenu() {
        let interactions = UIContextMenuInteraction(delegate: self)
        cardView.addInteraction(interactions)
    }
    
    // MARK: - Action
    @objc private func executionButtonTapped() {
        guard let date, date <= Date(), let recordDataProvider else { return }
        recordDataProvider.toggleRecord(date: date)
    }

    // MARK: - additional methods
    private func setExecutionButton() {
        guard let date, let recordDataProvider = self.recordDataProvider else { return }
        if recordDataProvider.hasRecord(date: date) {
            executionButton.backgroundColor = executionButton.backgroundColor?.withAlphaComponent(0.5)
            executionButton.setImage(UIImage(resource: .done), for: .normal)
        }
        else {
            executionButton.backgroundColor = executionButton.backgroundColor?.withAlphaComponent(1)
            executionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            executionButton.tintColor = .trackerWhite
        }
    }

    private func setExecutionLabel() {
        guard let recordDataProvider = self.recordDataProvider else { return }
        executionLabel.text = Helpers.countDays(countDays: recordDataProvider.recordCount)
    }
    
    private func setPinImage() {
        let isPinned = self.tracker?.isPinned ?? false
        pinImage.isHidden = !isPinned
    }
}

extension TrackersCollectionViewCell: RecordDataProviderDelegate {
    func recordsDidUpdate(id: UUID) {
        guard id == self.tracker?.id else { return }
        //DispatchQueue.main.async {
            self.setExecutionLabel()
            self.setExecutionButton()
            self.setPinImage()
        //}
    }
}

extension TrackersCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        let menu = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in
            let isPinned = self.tracker?.isPinned ?? false
            let pinAction = UIAction(
                title: isPinned ? Localization.unpin : Localization.pin,
                handler: { _ in
                    self.pinToggleTracker?(())
                }
            )
            let editAction = UIAction(
                title: Localization.edit,
                handler: { _ in
                    self.editTracker?(())
                }
            )
            let deleteAction = UIAction(
                title: Localization.delete,
                attributes: .destructive,
                handler: { _ in
                    self.deleteTracker?(())
                }
            )
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
        return menu
    }
}
