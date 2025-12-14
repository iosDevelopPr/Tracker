
import UIKit

final class StatisticsViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let statisticImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .statistica)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let statisticLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
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
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88)
        ])
        
        view.addSubview(statisticImage)
        
        NSLayoutConstraint.activate([
            statisticImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(statisticLabel)
        
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: statisticImage.bottomAnchor, constant: 8),
            statisticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
