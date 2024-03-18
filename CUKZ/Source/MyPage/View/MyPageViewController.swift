//
//  MyPageViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/18/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: - Properties
    private let myPageView = MyPageView()
    
    // MARK: - View 설정
    override func loadView() {
        view = myPageView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    private func prepare() {
        
    }
}
