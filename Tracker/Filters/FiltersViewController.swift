
import UIKit

final class FiltersViewController: UIViewController {
    
    private let filtersLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.filters
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let buttonTable: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .trackerForLightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private let buttonIdentifiers = [
        Localization.allTrackers,
        Localization.trackersForToday,
        Localization.finished,
        Localization.notFinished
    ]
    
    var delegate: FiltersViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = .trackerWhite
        
        setupFiltersLabel()
        setupTableView()
    }
    
    private func setupFiltersLabel() {
        view.addSubview(filtersLabel)

        NSLayoutConstraint.activate([
            filtersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            filtersLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filtersLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filtersLabel.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(buttonTable)
        
        buttonTable.register(
            FiltersButtonCell.self,
            forCellReuseIdentifier: FiltersButtonCell.reuseIdentifier
        )
        
        buttonTable.dataSource = self
        buttonTable.delegate = self
        
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 30),
            buttonTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FiltersButtonCell.reuseIdentifier,
            for: indexPath
        ) as? FiltersButtonCell else {
            return UITableViewCell()
        }
        
        let identifier = buttonIdentifiers[indexPath.row]

        switch identifier {
        case Localization.allTrackers:
            cell.configure(title: identifier, isSelected: true)
        case Localization.trackersForToday:
            cell.configure(title: identifier, isSelected: true)
        case Localization.finished:
            cell.configure(title: identifier, isSelected: true)
        case Localization.notFinished:
            cell.configure(title: identifier, isSelected: true)
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = buttonIdentifiers[indexPath.row]
        
        switch selectedOption {
        case Localization.allTrackers:
            delegate?.setFilter()
        case Localization.trackersForToday:
            delegate?.setFilter()
        case Localization.finished:
            delegate?.setFilter()
        case Localization.notFinished:
            delegate?.setFilter()
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
}
