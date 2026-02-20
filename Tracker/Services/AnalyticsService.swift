
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logEvent(event: EventAnalytics, screen: ScreenAnalytics, item: ItemAnalytics) {
        let eventParams: [String: Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue,
            "item": item.rawValue
        ]
        
        AppMetrica.reportEvent(name: "user_interaction", parameters: eventParams)
    }
}
