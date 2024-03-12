//
//  TabBarViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gadaeGray
        self.selectedIndex = 0
        
        tabBarConfig()
    }
    
    private func tabBarConfig() {
        tabBar.barTintColor = .gadaeGray
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
        let likeVC = UINavigationController(rootViewController: LikeViewController())
        
        // 탭 바 이이템 설정
        likeVC.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        let tabItems = [
            likeVC
        ]
        
        setViewControllers(tabItems, animated: true)
    }
    
}
