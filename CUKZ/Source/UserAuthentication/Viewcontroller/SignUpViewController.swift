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
        setupNaviBar()
    }
    
    private func prepare() {
        
    }
    
    private func setupNaviBar() {
        title = "회원가입"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
}
