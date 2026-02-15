import Foundation

enum Schedule: String, CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static func dayOfWeek(date: Date) -> Schedule {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return getSchedule(day: weekday)
    }
    
    var localized: String {
        switch self {
        case .monday: return Localization.locMonday
        case .tuesday: return Localization.locTuesday
        case .wednesday: return Localization.locWednesday
        case .thursday: return Localization.locThursday
        case .friday: return Localization.locFriday
        case .saturday: return Localization.locSaturday
        case .sunday: return Localization.locSunday
        }
    }

    static func getSchedule(day: Int) -> Schedule {
        switch day {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default : return .sunday
        }
    }

    var shortName: String {
        switch self {
        case .monday: return Localization.locMondayShort
        case .tuesday: return Localization.locTuesdayShort
        case .wednesday: return Localization.locWednesdayShort
        case .thursday: return Localization.locThursdayShort
        case .friday: return Localization.locFridayShort
        case .saturday: return Localization.locSaturdayShort
        case .sunday: return Localization.locSundayShort
        }
    }

    func getNameInt() -> String {
        switch self {
        case .monday: return "2"
        case .tuesday: return "3"
        case .wednesday: return "4"
        case .thursday: return "5"
        case .friday: return "6"
        case .saturday: return "7"
        case .sunday: return "1"
        }
    }
    
    static let sortedOrder: [Schedule] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    static func scheduleString(schedule: Set<Schedule>) -> String {
        if schedule.count == 7 {
            return Localization.everyDay
        }
        let sortedDays = schedule.sorted {
            sortedOrder.firstIndex(of: $0)! < sortedOrder.firstIndex(of: $1)!
        }
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
}
