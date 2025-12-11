
import UIKit

final class SchedulePageViewController: UIViewController {
    private let identifierCell: String = "ScheduleCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    } ()
    
    private let scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        return tableView
    } ()
    
    private let preparedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor(resource: .trackerWhite), for: .normal)
        button.backgroundColor = UIColor(resource: .trackerBackgroundBlack)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    } ()
    
    // MARK: - Properties
    private var selectedDays: Set<Schedule>
    private var presenter: NewTrackerPresenterProtocol

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(presenter: NewTrackerPresenterProtocol) {
        self.presenter = presenter
        self.selectedDays = presenter.tracker.schedule ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func preparedButtonPressed() {
        presenter.updateSchedule(schedule: selectedDays)
        dismiss(animated: true)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let selectedDay = Schedule.getSchedule(day: sender.tag)
        if sender.isOn {
            selectedDays.insert(selectedDay)
        } else {
            selectedDays.remove(selectedDay)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .trackerWhite)
        setupMainLabel()
        setupScheduleTable()
        setupButtons()
    }
    
    private func setupMainLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 37),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupScheduleTable() {
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.register(UITableViewCell.self, forCellReuseIdentifier: identifierCell)
        
        scheduleTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleTable)
        
        NSLayoutConstraint.activate([
            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTable.heightAnchor.constraint(equalToConstant: CGFloat(7) * 75),
        ])
    }
    
    private func setupButtons() {
        preparedButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preparedButton)
        
        preparedButton.addTarget(self, action: #selector(preparedButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            preparedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            preparedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            preparedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            preparedButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension SchedulePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 } // Высота ячейки
}

extension SchedulePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Schedule.allCases.count   // Кол-во ячеек в таблице (по дням недели)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        configureCell(cell, for: indexPath)
        let isLast = indexPath.row == 6

        if isLast {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        }

        return cell
    }
    
    // MARK: - Cell Configuration
    private func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let schedule = Schedule.allCases[indexPath.row]

        cell.textLabel?.text = schedule.rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = UIColor.systemGray6
        cell.selectionStyle = .none

        let switchView = createSwitch(for: indexPath)
        cell.accessoryView = switchView
    }

    private func createSwitch(for indexPath: IndexPath) -> UISwitch {
        let switchView = UISwitch()
        let dayIndex = (indexPath.row + 2) % 7
        switchView.tag = dayIndex == 0 ? 7 : dayIndex
        switchView.isOn = selectedDays.contains(Schedule.getSchedule(day: dayIndex))

        switchView.onTintColor = UIColor(resource: .trackerBlue)
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return switchView
    }
}
