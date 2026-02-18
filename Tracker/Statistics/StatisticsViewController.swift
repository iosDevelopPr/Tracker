
import UIKit

final class StatisticsViewController: UIViewController {
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let statisticTitle: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .statistica
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let placeholderText: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticPlaceholder
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let statisticsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let cardBestPeriod: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let bestPeriodValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let bestPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticBestPeriod
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let cardPerfectDays: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let perfectDaysValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let perfectDaysLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticPerfectDays
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let cardTrackersEnded: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let trackersEndedValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let trackersEndedLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticTrackersEnded
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let cardAverageValue: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let averageValueValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let averageValueLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.statisticAverageValue
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    private let dataProvider = StatisticDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        self.setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isDataExist = dataProvider.isDataExist()
        
        placeholderText.isHidden = isDataExist
        placeholderImage.isHidden = isDataExist
        statisticsView.isHidden = !isDataExist
        
        if isDataExist {
            loadStatistics()
        }
    }

    private func setupViewController() {
        setupHeader()
        setupPlaceholder()
        setupStatistics()
    }
    
    private func setupHeader() {
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 182)
        ])
        
        headerView.addSubview(statisticTitle)
        
        NSLayoutConstraint.activate([
            statisticTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 88)
        ])
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholderImage)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(placeholderText)
        
        NSLayoutConstraint.activate([
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStatistics() {
        view.addSubview(statisticsView)
        
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            statisticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statisticsView.heightAnchor.constraint(equalToConstant: 420)
        ])
        
        //--------------------------------------------------
        
        statisticsView.addSubview(cardBestPeriod)
        
        NSLayoutConstraint.activate([
            cardBestPeriod.topAnchor.constraint(equalTo: statisticsView.topAnchor, constant: 24),
            cardBestPeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardBestPeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardBestPeriod.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        cardBestPeriod.addSubview(bestPeriodValueLabel)
        
        NSLayoutConstraint.activate([
            bestPeriodValueLabel.topAnchor.constraint(equalTo: cardBestPeriod.topAnchor, constant: 12),
            bestPeriodValueLabel.heightAnchor.constraint(equalToConstant: 41),
            bestPeriodValueLabel.leadingAnchor.constraint(equalTo: cardBestPeriod.leadingAnchor, constant: 12),
            bestPeriodValueLabel.trailingAnchor.constraint(equalTo: cardBestPeriod.trailingAnchor, constant: -12)
        ])
        
        cardBestPeriod.addSubview(bestPeriodLabel)
        
        NSLayoutConstraint.activate([
            bestPeriodLabel.heightAnchor.constraint(equalToConstant: 19),
            bestPeriodLabel.leadingAnchor.constraint(equalTo: cardBestPeriod.leadingAnchor, constant: 12),
            bestPeriodLabel.trailingAnchor.constraint(equalTo: cardBestPeriod.trailingAnchor, constant: -12),
            bestPeriodLabel.bottomAnchor.constraint(equalTo: cardBestPeriod.bottomAnchor, constant: -12)
        ])
        
        cardBestPeriod.layoutIfNeeded()
        var gradient = getGradient(cardView: cardBestPeriod)
        cardBestPeriod.layer.addSublayer(gradient)

        //------------------------------------------
        
        statisticsView.addSubview(cardPerfectDays)
        
        NSLayoutConstraint.activate([
            cardPerfectDays.topAnchor.constraint(equalTo: cardBestPeriod.bottomAnchor, constant: 12),
            cardPerfectDays.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardPerfectDays.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardPerfectDays.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        cardPerfectDays.addSubview(perfectDaysValueLabel)
        
        NSLayoutConstraint.activate([
            perfectDaysValueLabel.topAnchor.constraint(equalTo: cardPerfectDays.topAnchor, constant: 12),
            perfectDaysValueLabel.heightAnchor.constraint(equalToConstant: 41),
            perfectDaysValueLabel.leadingAnchor.constraint(equalTo: cardPerfectDays.leadingAnchor, constant: 12),
            perfectDaysValueLabel.trailingAnchor.constraint(equalTo: cardPerfectDays.trailingAnchor, constant: -12)
        ])

        cardPerfectDays.addSubview(perfectDaysLabel)
        
        NSLayoutConstraint.activate([
            perfectDaysLabel.heightAnchor.constraint(equalToConstant: 19),
            perfectDaysLabel.leadingAnchor.constraint(equalTo: cardPerfectDays.leadingAnchor, constant: 12),
            perfectDaysLabel.trailingAnchor.constraint(equalTo: cardPerfectDays.trailingAnchor, constant: -12),
            perfectDaysLabel.bottomAnchor.constraint(equalTo: cardPerfectDays.bottomAnchor, constant: -12)
        ])
        
        cardPerfectDays.layoutIfNeeded()
        gradient = getGradient(cardView: cardPerfectDays)
        cardPerfectDays.layer.addSublayer(gradient)

        //------------------------------------------

        statisticsView.addSubview(cardTrackersEnded)
        
        NSLayoutConstraint.activate([
            cardTrackersEnded.topAnchor.constraint(equalTo: cardPerfectDays.bottomAnchor, constant: 12),
            cardTrackersEnded.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardTrackersEnded.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardTrackersEnded.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        cardTrackersEnded.addSubview(trackersEndedValueLabel)
        
        NSLayoutConstraint.activate([
            trackersEndedValueLabel.topAnchor.constraint(equalTo: cardTrackersEnded.topAnchor, constant: 12),
            trackersEndedValueLabel.heightAnchor.constraint(equalToConstant: 41),
            trackersEndedValueLabel.leadingAnchor.constraint(equalTo: cardTrackersEnded.leadingAnchor, constant: 12),
            trackersEndedValueLabel.trailingAnchor.constraint(equalTo: cardTrackersEnded.trailingAnchor, constant: -12)
        ])

        cardTrackersEnded.addSubview(trackersEndedLabel)
        
        NSLayoutConstraint.activate([
            trackersEndedLabel.heightAnchor.constraint(equalToConstant: 19),
            trackersEndedLabel.leadingAnchor.constraint(equalTo: cardTrackersEnded.leadingAnchor, constant: 12),
            trackersEndedLabel.trailingAnchor.constraint(equalTo: cardTrackersEnded.trailingAnchor, constant: -12),
            trackersEndedLabel.bottomAnchor.constraint(equalTo: cardTrackersEnded.bottomAnchor, constant: -12)
        ])
        
        cardTrackersEnded.layoutIfNeeded()
        gradient = getGradient(cardView: cardTrackersEnded)
        cardTrackersEnded.layer.addSublayer(gradient)

        //------------------------------------------

        statisticsView.addSubview(cardAverageValue)
        
        NSLayoutConstraint.activate([
            cardAverageValue.topAnchor.constraint(equalTo: cardTrackersEnded.bottomAnchor, constant: 12),
            cardAverageValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardAverageValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardAverageValue.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        cardAverageValue.addSubview(averageValueValueLabel)
        
        NSLayoutConstraint.activate([
            averageValueValueLabel.topAnchor.constraint(equalTo: cardAverageValue.topAnchor, constant: 12),
            averageValueValueLabel.heightAnchor.constraint(equalToConstant: 41),
            averageValueValueLabel.leadingAnchor.constraint(equalTo: cardAverageValue.leadingAnchor, constant: 12),
            averageValueValueLabel.trailingAnchor.constraint(equalTo: cardAverageValue.trailingAnchor, constant: -12)
        ])

        cardAverageValue.addSubview(averageValueLabel)
        
        NSLayoutConstraint.activate([
            averageValueLabel.heightAnchor.constraint(equalToConstant: 19),
            averageValueLabel.leadingAnchor.constraint(equalTo: cardAverageValue.leadingAnchor, constant: 12),
            averageValueLabel.trailingAnchor.constraint(equalTo: cardAverageValue.trailingAnchor, constant: -12),
            averageValueLabel.bottomAnchor.constraint(equalTo: cardAverageValue.bottomAnchor, constant: -12)
        ])
        
        cardAverageValue.layoutIfNeeded()
        gradient = getGradient(cardView: cardAverageValue)
        cardAverageValue.layer.addSublayer(gradient)
     }
    
    private func loadStatistics() {
        bestPeriodValueLabel.text = "\(dataProvider.recordsBestPeriod())"
        perfectDaysValueLabel.text = "\(dataProvider.countDayMaxRecord())"
        trackersEndedValueLabel.text = "\(dataProvider.trackersEnded())"
        averageValueValueLabel.text = String(format: "%.1f", dataProvider.recordsAveragePerDay())
    }
    
    private func getGradient(cardView: UIView) -> CAGradientLayer {
        
        let cornerRadius: CGFloat = 16
        let lineWidth: CGFloat = 2
        
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = lineWidth
        borderLayer.fillColor = nil
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.frame = cardBestPeriod.bounds
        borderLayer.path = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius).cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#FD4C49").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#007BFA").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = cornerRadius
        
        gradientLayer.mask = borderLayer
        
        return gradientLayer
    }
}
