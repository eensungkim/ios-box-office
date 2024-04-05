//
//  BoxOfficeTabBarController.swift
//  BoxOffice
//
//  Created by LeeSeongYeon on 2024/03/13.
//

import UIKit

final class BoxOfficeTabBarController: UITabBarController {
    enum Tab: Int {
        case boxOffice
        case trailerSearch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
    }
}

// MARK: - UI
extension BoxOfficeTabBarController {
    private func setupTabBarAppearance() {
        tabBar.backgroundColor = .systemBackground
    }
}

// MARK: - Configurations
extension BoxOfficeTabBarController {
    private func setupViewControllers() {
        let boxOfficeViewController = BoxOfficeViewController()
        boxOfficeViewController.tabBarItem = Tab.boxOffice.tabBarItem
        let boxOfficeNavigationController = UINavigationController(rootViewController: boxOfficeViewController)
        
        let arSearchTrailerViewController = ARSearchTrailerViewController()
        arSearchTrailerViewController.tabBarItem = Tab.trailerSearch.tabBarItem
        
        setViewControllers([boxOfficeNavigationController, arSearchTrailerViewController], animated: true)
    }
}

extension BoxOfficeTabBarController.Tab {
    fileprivate var tabBarItem: UITabBarItem {
        switch self {
        case .boxOffice:
            return UITabBarItem(
                title: "박스오피스 순위",
                image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                tag: self.rawValue
            )
        case .trailerSearch:
            return UITabBarItem(
                title: "트레일러 검색",
                image: UIImage(systemName: "camera.metering.center.weighted"),
                tag: self.rawValue
            )
        }
    }
}
