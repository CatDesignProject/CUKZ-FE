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
        delegate = self
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

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // 로그인 상태에 따라 동작 설정
        if selectedIndex == 1 && !AppDelegate.isLogin { // likeVC를 클릭하고 로그인하지 않은 경우
            showAlertWithDismissDelay(message: "로그인 후 이용해주세요.")
            return false // 좋아요 탭으로 이동하지 않음
        }
        
        return true // 다른 탭 선택 허용
    }
}
