
final class TrackersManager {
    static let shared: TrackersManager = TrackersManager()
    
    private var trackers: [AnyObject] = []
    
    private init() {}
}
