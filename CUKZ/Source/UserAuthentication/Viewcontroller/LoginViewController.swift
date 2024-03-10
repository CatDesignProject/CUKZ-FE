//
//  LoginViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginMainView = LoginMainView()
    
    // MARK: - View 설정
    override func loadView() {
        view = loginMainView
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
