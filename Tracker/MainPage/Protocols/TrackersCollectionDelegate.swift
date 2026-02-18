
import UIKit

protocol TrackersCollectionDelegate: UIViewController {
    func updateUI()
    var darkMode: Bool { get }
}
