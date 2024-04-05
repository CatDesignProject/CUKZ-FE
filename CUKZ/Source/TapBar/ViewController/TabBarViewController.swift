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
        view.backgroundColor = .white
        
        tabBarConfig()
    }
    
    private func tabBarConfig() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .gadaeBlue
        tabBar.isTranslucent = false
        
        let productHomeVC = UINavigationController(rootViewController: ProductHomeViewController())
        let likeVC = UINavigationController(rootViewController: LikeViewController())
        let myPageVC = UINavigationController(rootViewController: LoginViewController())
        
        // 탭 바 이이템 설정
        productHomeVC.tabBarItem = UITabBarItem(
            title: "상품",
            image: UIImage(systemName: "wonsign.circle"),
            selectedImage: UIImage(systemName: "wonsign.circle.fill")
        )
        likeVC.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        myPageVC.tabBarItem = UITabBarItem(
            title: "MY",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        let tabItems = [
            productHomeVC,
            likeVC,
            myPageVC
        ]
        
        setViewControllers(tabItems, animated: true)
    }
    
}
