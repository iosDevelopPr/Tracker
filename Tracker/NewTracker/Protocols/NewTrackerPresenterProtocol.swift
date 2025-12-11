
protocol NewTrackerPresenterProtocol {
    var tracker: Tracker { get }
    
    func configure(view: NewTrackerViewControllerProtocol)
    
    func updateName(name: String)
    func updateSchedule(schedule: Set<Schedule>)
    func scheduleString() -> String
    func categoryString() -> String
    
    func dataFilled() -> Bool
    
    func createTracker()
}
