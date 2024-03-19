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
        
        view.backgroundColor = .gadaeBlue
        self.selectedIndex = 0
        
        tabBarConfig()
    }
    
    private func tabBarConfig() {
        tabBar.barTintColor = .gadaeBlue
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
        let purchaseHomeVC = UINavigationController(rootViewController: PurchaseHomeViewController())
        let likeVC = UINavigationController(rootViewController: LikeViewController())
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        
        // 탭 바 이이템 설정
        purchaseHomeVC.tabBarItem = UITabBarItem(
            title: "구매하기",
            image: UIImage(systemName: "wonsign.circle"),
            selectedImage: UIImage(systemName: "wonsign.circle.fill")
        )
        likeVC.tabBarItem = UITabBarItem(
            title: "찜",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        myPageVC.tabBarItem = UITabBarItem(
            title: "MY",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        let tabItems = [
            purchaseHomeVC,
            likeVC,
            myPageVC
        ]
        
        setViewControllers(tabItems, animated: true)
    }
    
}
