
import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let storage: UserDefaults = .standard
    
    private init() {}
    
    private enum Key {
        static let notRunOnboarding = "notRunOnboarding"
    }
    
    var isNotRunOnboarding: Bool {
        get { storage.bool(forKey: Key.notRunOnboarding) }
        set { storage.set(newValue, forKey: Key.notRunOnboarding) }
    }
}
