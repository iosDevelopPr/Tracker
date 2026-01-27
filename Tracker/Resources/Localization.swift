
import Foundation

enum Localization {
    
    static let trackersTitle = localized("trackers")
    static let statisticTitle = localized("statistic")
    static let searchPlaceholder = localized("search")
    
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
