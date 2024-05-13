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
    
    // MARK: - viewDidLoad
    override func viewDidLoad () {
        super.viewDidLoad ()

        setupNaviBar()
        setupNotifications()
        setupTextField()
        setupButton()
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTextField() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    private func setupButton() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        print("로그인 눌림")
        guard let username = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else { return }
        
        UserNetworkManager.shared.postLogin(username: username,
                                             password: password) { JSESSIONID, responseBody in
            
            guard let JSESSIONID = JSESSIONID else { return }
            print("JSESSIONID: \(JSESSIONID)")
            
            guard let responseBody = responseBody else { return }
            guard let memberId = responseBody["memberId"] as? Int,
                  let nickname = responseBody["nickname"] as? String,
                  let role = responseBody["role"] as? String else { return }
            
            // 로그인 성공시 JSESSIONID 저장
            self.loginSuccess(sessionId: JSESSIONID, username: username, password: password)
            
            if let tabBarVC = self.tabBarController as? TabBarViewController {
                guard var viewControllers = tabBarVC.viewControllers else { return }
                
                let VC = MyPageViewController()
                VC.nickName = nickname
                VC.role = role

                let myPageNavController = UINavigationController(rootViewController: VC)
                myPageNavController.tabBarItem = UITabBarItem(
                    title: "MY",
                    image: UIImage(systemName: "person.circle"),
                    selectedImage: UIImage(systemName: "person.circle.fill")
                )
                viewControllers[2] = myPageNavController
                tabBarVC.setViewControllers(viewControllers, animated: true)
            }
        }
    }

    
    // UserDefaults
    private func loginSuccess(sessionId:String, username: String, password: String) {
        UserDefaults.standard.set(sessionId, forKey: "sessionId")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    // 회원가입 버튼 눌림
    @objc func signUpButtonTapped() {
        let VC = SignUpViewController()
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
}

// MARK: - 키보드 관련
extension LoginViewController {
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == loginView.emailTextField {
            loginView.emailTextFieldView.backgroundColor = .white
            loginView.emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
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
        
        if textField == loginView.emailTextField {
            loginView.emailTextFieldView.backgroundColor = .white
            
            if loginView.emailTextField.text == "" {
                loginView.emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
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
            let email = loginView.emailTextField.text, !email.isEmpty,
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
