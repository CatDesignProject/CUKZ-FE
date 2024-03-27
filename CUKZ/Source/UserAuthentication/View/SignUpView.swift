//
//  SignUpView.swift
//  CUKZ
//
//  Created by 이승민 on 3/21/24.
//

import UIKit

final class SignUpView: UIView {
    // MARK: - View
    let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    // 아이디
    private let idLabel = UILabel().then() {
        $0.text = "아이디"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let idRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let idTextField = UITextField().then {
        $0.placeholder = "아이디를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    // 비밀번호
    private let passwordLabel = UILabel().then() {
        $0.text = "비밀번호"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let passwordRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    // 닉네임
    private let nicknameLabel = UILabel().then() {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let nicknameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    // 가입하기 버튼
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = .gadaeBlue
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        self.addSubviews([scrollView, signUpButton])
        
        scrollView.addSubviews([contentView])
        
        contentView.addSubviews([idLabel,
                                 idRoundView,
                                 passwordLabel,
                                 passwordRoundView,
                                 nicknameLabel,
                                 nicknameRoundView])
        
        idRoundView.addSubviews([idTextField])
        passwordRoundView.addSubviews([passwordTextField])
        nicknameRoundView.addSubviews([nicknameTextField])
    }
    
    private func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.edges.equalTo(scrollView)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        idRoundView.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom)
            make.leading.trailing.equalTo(idLabel)
            make.height.equalTo(50)
        }
        
        idTextField.snp.makeConstraints { make in
            make.edges.equalTo(idRoundView).inset(5)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idRoundView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(idLabel)
        }
        
        passwordRoundView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom)
            make.leading.trailing.equalTo(idLabel)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalTo(passwordRoundView).inset(5)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordRoundView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(idLabel)
        }
        
        nicknameRoundView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.trailing.equalTo(idLabel)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.edges.equalTo(nicknameRoundView).inset(5)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
    }
}
