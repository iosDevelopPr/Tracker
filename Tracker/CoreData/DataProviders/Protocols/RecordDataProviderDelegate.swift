
import Foundation

protocol RecordDataProviderDelegate: AnyObject {
    func recordsDidUpdate(id: UUID)
}
