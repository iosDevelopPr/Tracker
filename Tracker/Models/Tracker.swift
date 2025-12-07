import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let schedule: Set<Schedule>?
}
