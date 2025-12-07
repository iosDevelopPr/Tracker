//
//  TabBarController.swift
//  Tracker
//
//  Created by Igor on 26.11.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case trackers
        case statistics
        
        var title: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case .statistics:
                return "Статистика"
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
                let trackersViewController = TrackersViewController()
                let trackersNavigationItem = UINavigationController(rootViewController: trackersViewController)
                trackersNavigationItem.navigationBar.tintColor = .trackerBackgroundBlack
                return trackersNavigationItem
            case .statistics:
                let statisticsViewController = StatisticsViewController()
                return UINavigationController(rootViewController: statisticsViewController)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = dataSource[$0].icon
            
            $1.tabBarItem.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 24)], for: .selected)
        }
    }
}
