
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logEvent(event: String, screen: String, item: String) {
        let eventParams: [String: Any] = [
            "event": event,
            "screen": screen,
            "item": item
        ]
        
        AppMetrica.reportEvent(name: "user_interaction", parameters: eventParams)
    }
}
