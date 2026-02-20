
import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case trackers
        case statistics
        
        var title: String {
            switch self {
            case .trackers:
                return Localization.trackersTitle
            case .statistics:
                return Localization.statisticTitle
            }
        }
        
        var icon: UIImage {
            switch self {
            case .trackers:
                return UIImage(systemName: "record.circle.fill") ?? UIImage()
            case .statistics:
                return UIImage(systemName: "hare.fill") ?? UIImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.trackers, .statistics]
        
        self.viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                return UINavigationController(
                    rootViewController: TrackersViewController())
            case .statistics:
                return UINavigationController(
                    rootViewController: StatisticsViewController())
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = dataSource[$0].icon
            
            $1.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10)], for: .selected)
        }
    }
}
