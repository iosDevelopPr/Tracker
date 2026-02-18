
import Foundation

final class StatisticDataProvider {
    private let dataStore = StatisticDataStore()
    
    func trackersEnded() -> Int {
        return dataStore.trackersEnded()
    }
    
    func recordsBestPeriod() -> Int {
        return dataStore.recordsBestPeriod()
    }
    
    func recordsAveragePerDay() -> Float {
        return dataStore.recordsAveragePerDay()
    }
    
    func countDayMaxRecord() -> Int {
        return dataStore.countDayMaxRecord()
    }
    
    func isDataExist() -> Bool {
        return
            dataStore.trackersEnded() > 0 ||
            dataStore.recordsAveragePerDay() > 0 ||
            dataStore.recordsBestPeriod() > 0
    }
}
