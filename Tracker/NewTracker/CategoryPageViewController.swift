
import UIKit

final class CategoryPageViewController: UIViewController {
    private let dizzyImageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    } ()
    
    private let textLabel: UILabel = {
        let Label = UILabel()
        Label.text = "Привычки и события можно\nобъединить по смыслу"
        Label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        Label.textAlignment = .center
        Label.numberOfLines = 2
        return Label
    } ()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .trackerWhite)
        setupUI()
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupDizzyImage()
        setupTextLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupDizzyImage() {
        dizzyImageView.image = UIImage(resource: .dizzy)
        dizzyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dizzyImageView)
        
        NSLayoutConstraint.activate([
            dizzyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dizzyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: dizzyImageView.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
