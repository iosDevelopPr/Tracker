struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
    
    init(name: String, trackers: [Tracker] = []) {
        self.name = name
        self.trackers = trackers
    }
    
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        return lhs.name == rhs.name
    }
}
