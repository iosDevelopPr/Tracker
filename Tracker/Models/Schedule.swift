import Foundation

enum Schedule: String, CaseIterable, Codable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    static func dayOfWeek(date: Date) -> Schedule {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return getSchedule(day: weekday)
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

    func shortName() -> String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }

    static let sortedOrder: [Schedule] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    static func scheduleString(schedule: Set<Schedule>) -> String {
        if schedule.count == 7 {
            return "Каждый день"
        }
        let sortedDays = schedule.sorted {
            sortedOrder.firstIndex(of: $0)! < sortedOrder.firstIndex(of: $1)!
        }
        return sortedDays.map { $0.shortName() }.joined(separator: ", ")
    }
}
