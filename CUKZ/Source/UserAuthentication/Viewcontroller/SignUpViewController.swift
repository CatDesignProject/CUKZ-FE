//
//  SignUpViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/21/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    private let signUpView = SignUpView()
    
    // MARK: - View 설정
    override func loadView() {
        view = signUpView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    private func prepare() {
        
    }
}
