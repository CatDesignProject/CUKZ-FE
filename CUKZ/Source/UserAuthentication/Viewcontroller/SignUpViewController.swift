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
        setupKeyboardNotification()
        setupTextField()
        setupButton()
    }
    
    private func prepare() {
        
    }
    
    private func setupNaviBar() {
        title = "회원가입"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @objc private func duplicateCheckButtonTapped() {
        print("중복체크 버튼 눌림")
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
