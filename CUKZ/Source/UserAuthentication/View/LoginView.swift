//
//  LoginView.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit
import SnapKit
import Then

final class LoginView: UIView {
    // MARK: - View
    let loginInfoLabel = UILabel().then {
        $0.text = "아이디 또는 비밀번호를 잘못 입력했습니다.\n입력하신 내용을 다시 확인해주세요."
        $0.textAlignment = .center
        $0.textColor = .red
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    let dismissButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    let idTextFieldView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }

    let idInfoLabel = UILabel().then() {
        $0.text = "아이디"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .gadaeBlue
    }
    
    let idTextField = UITextField().then {
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
        idTextFieldView.addSubviews([idInfoLabel, idTextField])
        passwordTextFieldView.addSubviews([passwordInfoLabel, passwordTextField])
        
        stackView.addArrangedSubviews([idTextFieldView, passwordTextFieldView, loginButton])
        
        self.addSubviews([dismissButton,
                          loginInfoLabel,
                          stackView,
                          signUpButton])
    }
    
    let textViewHeight: CGFloat = 48
    
    var emailInfoLabelCenterYConstraint: Constraint?
    var passwordInfoLabelCenterYConstraint: Constraint?
    
    private func configureConstraints() {
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        loginInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        idInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(idTextFieldView).inset(8)
            emailInfoLabelCenterYConstraint = make.centerY.equalTo(idTextFieldView).constraint
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextFieldView).offset(15)
            make.leading.trailing.equalTo(idTextFieldView).inset(8)
            make.bottom.equalTo(idTextFieldView).inset(2)
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
