
import Foundation

enum Localization {

    static let onboardingButton = localized("onboardingButton")
    static let onboardingFirstPage = localized("onboardingFirstPage")
    static let onboardingSecondPage = localized("onboardingSecondPage")

    static let newTrackerTitle = localized("newTrackerTitle")
    static let editTrackerTitle = localized("editTrackerTitle")

    static let trackersTitle = localized("trackers")
    static let statisticTitle = localized("statistic")
    static let searchPlaceholder = localized("search")
    
    static let statisticPlaceholder = localized("statisticPlaceholder")
    static let nameFieldMaxLengthLabel = localized("nameFieldMaxLengthLabel")
    
    static let trackerListPlaceholder = localized("trackerListPlaceholder")
    static let categoryListPlaceholder = localized("categoryListPlaceholder")
    static let trackerPlaceholder = localized("trackerPlaceholder")
    static let categoryPlaceholder = localized("categoryPlaceholder")
    
    static let categoryTitle = localized("category")
    static let scheduleTitle = localized("schedule")
    static let addCategoryButton = localized("addCategory")
    static let newCategoryTitle = localized("newCategory")
    static let editCategoryTitle = localized("editCategory")

    static let cancelButton = localized("cancel")
    static let createButton = localized("create")
    static let saveButton = localized("save")
    static let readyButton = localized("ready")
    
    static let colorTitle = localized("color")
    static let emojiTitle = localized("emoji")

    static let pin = localized("pin")
    static let pinned = localized("pinned")
    static let unpin = localized("unpin")
    static let edit = localized("edit")
    static let delete = localized("delete")
    static let deleteConfirmation = localized("deleteConfirmation")
    
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
