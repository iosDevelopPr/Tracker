
import Foundation
import CoreData

final class StatisticDataStore {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.managedObjectContext
    }
    
    func trackersEnded() -> Int {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.resultType = .countResultType
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }
    
    func recordsBestPeriod() -> Int {
        let request = NSFetchRequest<NSDictionary>(entityName: "RecordCoreData")
        request.resultType = .dictionaryResultType
        
        let countExpression = NSExpressionDescription()
        countExpression.name = "recordCount"
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "date")])
        countExpression.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = ["date", countExpression]
        request.propertiesToGroupBy = ["date"]
        
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0["recordCount"] as? Int }.max() ?? 0
        } catch {}
        return 0
    }
    
    func recordsAveragePerDay() -> Float {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        
        request.propertiesToFetch = ["date"]
        
        var countDays: Int = 0
        do {
            let result = try context.fetch(request)
            countDays = result.count
        } catch {
            countDays = 0
        }
        
        if countDays > 0 {
            let countRecords = trackersEnded()
            return Float(countRecords) / Float(countDays)
        } else {
            return 0
        }
    }
    
    func countDayMaxRecord() -> Int {
        let request = NSFetchRequest<NSDictionary>(entityName: "RecordCoreData")
        request.resultType = .dictionaryResultType
        
        let countExpression = NSExpressionDescription()
        countExpression.name = "recordCount"
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "date")])
        countExpression.expressionResultType = .integer32AttributeType
        
        let sortExpression = NSSortDescriptor(key: "recordCount", ascending: false)

        request.propertiesToFetch = ["date", countExpression]
        request.propertiesToGroupBy = ["date"]
        request.sortDescriptors = [sortExpression]

        do {
            let results = try context.fetch(request)
            
            var filterMax = 0
            if results.count > 0 {
                filterMax = results[0]["recordCount"] as? Int ?? 0
                return results.filter { $0["recordCount"] as? Int == filterMax }.count
            }
        } catch {}
        return 0
    }
}
