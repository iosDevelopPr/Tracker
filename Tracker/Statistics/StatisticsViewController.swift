
import UIKit

final class StatisticsViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.setupViewController()
    }
    
    private func setupViewController() {
        view.addSubview(statisticTitle)
        
        NSLayoutConstraint.activate([
            statisticTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 88)
        ])
        
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
}
