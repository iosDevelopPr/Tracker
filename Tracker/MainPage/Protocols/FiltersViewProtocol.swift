
import UIKit

protocol FiltersViewProtocol: UIViewController {
    func setFilter(filter: FilterChoice)
    func getFilter() -> FilterChoice
}
