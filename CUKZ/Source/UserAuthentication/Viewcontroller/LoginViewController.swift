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
    override func viewDidLoad () {
        super.viewDidLoad ()
        
        prepare()
        setupNotifications()
        setupTextField()
        setupButton()
    }
    
    private func prepare() {
        
    }
    
    private func setupTextField() {
        loginMainView.emailTextField.delegate = self
        loginMainView.passwordTextField.delegate = self
        
        loginMainView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginMainView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    private func setupButton() {
        loginMainView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginMainView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        print("로그인 눌림")
    }
    
    @objc func signUpButtonTapped() {
        print("회원가입 화면으로")
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
        
        if textField == loginMainView.emailTextField {
            loginMainView.emailTextFieldView.backgroundColor = .white
            loginMainView.emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            loginMainView.emailInfoLabelCenterYConstraint?.update(offset: -13)
        }
        if textField == loginMainView.passwordTextField {
            loginMainView.passwordTextFieldView.backgroundColor = .white
            loginMainView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            loginMainView.passwordInfoLabelCenterYConstraint?.update(offset: -13)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.loginMainView.stackView.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == loginMainView.emailTextField {
            loginMainView.emailTextFieldView.backgroundColor = .white
            
            if loginMainView.emailTextField.text == "" {
                loginMainView.emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                loginMainView.emailInfoLabelCenterYConstraint?.update(offset: 0)
            }
        }
        if textField == loginMainView.passwordTextField {
            loginMainView.passwordTextFieldView.backgroundColor = .white
            
            if loginMainView.passwordTextField.text == "" {
                loginMainView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                loginMainView.passwordInfoLabelCenterYConstraint?.update(offset: 0)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.loginMainView.stackView.layoutIfNeeded()
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
            let email = loginMainView.emailTextField.text, !email.isEmpty,
            let password = loginMainView.passwordTextField.text, !password.isEmpty
        else {
            loginMainView.loginButton.backgroundColor = .clear
            loginMainView.loginButton.isEnabled = false
            return
        }
        loginMainView.loginButton.backgroundColor = .gadaeGray
        loginMainView.loginButton.isEnabled = true
    }
    
    // 엔터 누르면 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
