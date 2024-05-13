//
//  SignUpViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/21/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    private let networkManager = UserNetworkManager.shared
    private let signUpView = SignUpView()
    
    // MARK: - View 설정
    override func loadView() {
        view = signUpView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupKeyboardNotification()
        setupTextField()
        setupButton()
    }
    
    private func setupNaviBar() {
        title = "회원가입"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTextField() {
        signUpView.idTextField.delegate = self
        signUpView.passwordTextField.delegate = self
        signUpView.secondPasswordTextField.delegate = self
        signUpView.nicknameTextField.delegate = self
    }
    
    private func setupButton() {
        signUpView.duplicateCheckButton.addTarget(
            self,
            action: #selector(duplicateCheckButtonTapped),
            for: .touchUpInside
        )
        signUpView.completeButton.addTarget(
            self,
            action: #selector(completeButtonButtonTapped),
            for: .touchUpInside
        )
    }
}

// MARK: - @objc
extension SignUpViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        signUpView.scrollView.contentInset = contentInsets
        signUpView.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = view.frame
        aRect.size.height -= keyboardHeight
        
        if let activeTextField = findActiveTextField(in: signUpView.contentView) {
            if !aRect.contains(activeTextField.frame.origin) {
                signUpView.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        signUpView.scrollView.contentInset = contentInsets
        signUpView.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func findActiveTextField(in view: UIView) -> UITextField? {
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            } else if let foundTextField = findActiveTextField(in: subview) {
                return foundTextField
            }
        }
        return nil
    }
    
    // 아이디 중복체크
    @objc private func duplicateCheckButtonTapped() {
        guard let username = signUpView.idTextField.text else { return }
        view.endEditing(true)
        
        UserNetworkManager.shared.postDuplicateCheck(username: username) { isDuplicate in
            guard let isDuplicate = isDuplicate else { return }
            
            DispatchQueue.main.async {
                self.signUpView.duplicateCheckLabel.isHidden = false
                
                if isDuplicate { // 중복일때 isDuplicate == true
                    self.signUpView.duplicateCheckLabel.text = "이미 사용 중인 아이디입니다."
                    self.signUpView.duplicateCheckLabel.textColor = .red
                } else { // 사용가능할때 isDuplicate == false
                    self.signUpView.duplicateCheckLabel.text = "사용 가능한 아이디입니다."
                    self.signUpView.duplicateCheckLabel.textColor = .blue
                }
            }
        }
    }
    
    @objc private func completeButtonButtonTapped() {
        print("회원가입 버튼 눌림")
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
