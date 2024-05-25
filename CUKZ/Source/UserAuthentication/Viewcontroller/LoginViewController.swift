//
//  LoginViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    
    // MARK: - View 설정
    override func loadView() {
        view = loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad () {
        super.viewDidLoad ()

        setupNaviBar()
        setupTextField()
        setupButton()
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTextField() {
        loginView.idTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.idTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    private func setupButton() {
        loginView.loginButton.addTarget(self, 
                                        action: #selector(loginButtonTapped),
                                        for: .touchUpInside)
        
        loginView.signUpButton.addTarget(self,
                                         action: #selector(signUpButtonTapped),
                                         for: .touchUpInside)
        
        loginView.dismissButton.addTarget(self,
                                          action: #selector(dismissButtonTapped),
                                          for: .touchUpInside)
    }

    // UserDefaults
    private func loginSuccess(sessionId:String, username: String, password: String) {
        UserDefaults.standard.set(sessionId, forKey: "sessionId")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
    }
}

extension LoginViewController {
    // 닫기 버튼
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 로그인 버튼
    @objc private func loginButtonTapped() {
        guard let username = loginView.idTextField.text,
              let password = loginView.passwordTextField.text else { return }
        
        UserNetworkManager.shared.postLogin(username: username,
                                            password: password) { result in
            switch result {
            case .success(let data):
                print("로그인 성공")
                AppDelegate.isLogin = true
                AppDelegate.memberId = data.memberId
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("로그인 실패 \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.loginView.loginInfoLabel.isHidden = false
                }
            }
        }
    }
    
    // 회원가입 버튼
    @objc private func signUpButtonTapped() {
        let VC = SignUpViewController()
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == loginView.idTextField {
            loginView.idTextFieldView.backgroundColor = .white
            loginView.idInfoLabel.font = UIFont.systemFont(ofSize: 11)
            loginView.emailInfoLabelCenterYConstraint?.update(offset: -13)
        }
        if textField == loginView.passwordTextField {
            loginView.passwordTextFieldView.backgroundColor = .white
            loginView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            loginView.passwordInfoLabelCenterYConstraint?.update(offset: -13)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.loginView.stackView.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == loginView.idTextField {
            loginView.idTextFieldView.backgroundColor = .white
            
            if loginView.idTextField.text == "" {
                loginView.idInfoLabel.font = UIFont.systemFont(ofSize: 18)
                loginView.emailInfoLabelCenterYConstraint?.update(offset: 0)
            }
        }
        if textField == loginView.passwordTextField {
            loginView.passwordTextFieldView.backgroundColor = .white
            
            if loginView.passwordTextField.text == "" {
                loginView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                loginView.passwordInfoLabelCenterYConstraint?.update(offset: 0)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.loginView.stackView.layoutIfNeeded()
        }
    }
    
    // 텍스트필드 모두 채워지면 로그인버튼 색상 변경
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = loginView.idTextField.text, !email.isEmpty,
            let password = loginView.passwordTextField.text, !password.isEmpty
        else {
            loginView.loginButton.backgroundColor = .clear
            loginView.loginButton.isEnabled = false
            return
        }
        loginView.loginButton.backgroundColor = .gadaeGray
        loginView.loginButton.isEnabled = true
    }
    
    // 엔터 누르면 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
