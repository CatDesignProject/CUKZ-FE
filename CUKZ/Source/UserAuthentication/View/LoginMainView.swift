//
//  LoginMainView.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit
import SnapKit
import Then

final class LoginMainView: UIView {
    // MARK: - View
    let emailTextFieldView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }

    let emailInfoLabel = UILabel().then() {
        $0.text = "이메일주소"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .gadaeBlue
    }
    
    let emailTextField = UITextField().then {
        $0.frame.size.height = 48
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.tintColor = .white
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.keyboardType = .emailAddress
    }
    
    let passwordTextFieldView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    let passwordInfoLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .gadaeBlue
    }
    
    let passwordTextField = UITextField().then {
        $0.frame.size.height = 48
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.tintColor = .white
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true
        $0.clearsOnBeginEditing = false
    }
    
    let loginButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isEnabled = false
    }
    
    let stackView = UIStackView().then {
        $0.spacing = 18
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let signUpButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gadaeBlue
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        emailTextFieldView.addSubviews([emailInfoLabel, emailTextField])
        passwordTextFieldView.addSubviews([passwordInfoLabel, passwordTextField])
        
        stackView.addArrangedSubviews([emailTextFieldView, passwordTextFieldView, loginButton])
        
        self.addSubviews([stackView, signUpButton])
    }
    
    let textViewHeight: CGFloat = 48
    
    var emailInfoLabelCenterYConstraint: Constraint?
    var passwordInfoLabelCenterYConstraint: Constraint?
    
    private func configureConstraints() {
        
        emailInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(emailTextFieldView).inset(8)
            emailInfoLabelCenterYConstraint = make.centerY.equalTo(emailTextFieldView).constraint
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView).offset(15)
            make.leading.trailing.equalTo(emailTextFieldView).inset(8)
            make.bottom.equalTo(emailTextFieldView).inset(2)
        }
        
        passwordInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(passwordTextFieldView).inset(8)
            passwordInfoLabelCenterYConstraint = make.centerY.equalTo(passwordTextFieldView).constraint
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView).offset(15)
            make.leading.trailing.equalTo(passwordTextFieldView).inset(8)
            make.bottom.equalTo(passwordTextFieldView).inset(2)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(textViewHeight * 3 + 36)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.centerX.equalTo(stackView)
            make.height.equalTo(textViewHeight)
        }
    }
    
}
