//
//  SignUpViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/21/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    private var isDuplicateId = true // true면 아이디 중복
    private var isValidPassword = false
    private var isValidNickname = false
    
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
    
    // 아이디 유효성 검사
    func isValidID(_ id: String) -> Bool {
        let idRegex = "^[a-zA-Z_][a-zA-Z0-9_]{4,15}$"
        return NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }

    // 비밀번호 유효성 검사
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[~!@#$%^&*])[A-Za-z\\d~!@#$%^&*]{8,16}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // 닉네임 유효성 검사
    private func isValidNickname(_ nickname: String) -> Bool {
        return !nickname.contains(" ")
    }
    
    // 버튼 상태 업데이트
    private func updateSignUpButtonState() {
        if !isDuplicateId && isValidPassword && isValidNickname {
            signUpView.completeButton.isEnabled = true
            signUpView.completeButton.backgroundColor = .gadaeBlue
        } else {
            signUpView.completeButton.isEnabled = false
            signUpView.completeButton.backgroundColor = .lightGray
        }
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
        
        if !isValidID(username) { // 아이디 유효성 검사
            self.isDuplicateId = true
            signUpView.duplicateCheckLabel.isHidden = false
            signUpView.duplicateCheckLabel.text = "아이디 형식이 올바르지 않습니다."
            signUpView.duplicateCheckLabel.textColor = .red
            return
        }
        
        UserNetworkManager.shared.postDuplicateCheck(username: username) { isDuplicate in
            guard let isDuplicate = isDuplicate else { return }
            
            DispatchQueue.main.async {
                self.signUpView.duplicateCheckLabel.isHidden = false
                
                if isDuplicate { // 중복일때 isDuplicate == true
                    self.isDuplicateId = true
                    self.signUpView.duplicateCheckLabel.text = "이미 사용 중인 아이디입니다."
                    self.signUpView.duplicateCheckLabel.textColor = .red
                } else { // 사용가능할때 isDuplicate == false
                    self.isDuplicateId = false
                    self.signUpView.duplicateCheckLabel.text = "사용 가능한 아이디입니다."
                    self.signUpView.duplicateCheckLabel.textColor = .blue
                }
                self.updateSignUpButtonState()
            }
        }
    }
    
    // 회원가입
    @objc private func completeButtonButtonTapped() {
        print("회원가입 버튼 눌림")
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == signUpView.passwordTextField {
            guard let password = textField.text else { return }
            if !isValidPassword(password) {
                self.isValidPassword = false
                signUpView.passwordValidationLabel.isHidden = false
                signUpView.passwordValidationLabel.text = "비밀번호는 8~16자의 문자, 숫자,\n특수문자(~,!,@,#,$,%,^,&,*)를 포함해야 합니다."
                signUpView.passwordValidationLabel.textColor = .red
            } else {
                self.isValidPassword = true
                signUpView.passwordValidationLabel.isHidden = false
                signUpView.passwordValidationLabel.text = "사용 가능한 비밀번호입니다."
                signUpView.passwordValidationLabel.textColor = .blue
            }
        } else if textField == signUpView.nicknameTextField {
            guard let nickname = textField.text else { return }
            if !isValidNickname(nickname) || nickname.isEmpty {
                self.isValidNickname = false
                signUpView.nicknameValidationLabel.isHidden = false
                signUpView.nicknameValidationLabel.text = "닉네임에 공백을 포함할 수 없습니다."
                signUpView.nicknameValidationLabel.textColor = .red
            } else {
                self.isValidNickname = true
                signUpView.nicknameValidationLabel.isHidden = false
                signUpView.nicknameValidationLabel.text = "사용 가능한 닉네임입니다."
                signUpView.nicknameValidationLabel.textColor = .blue
            }
        }
        updateSignUpButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
