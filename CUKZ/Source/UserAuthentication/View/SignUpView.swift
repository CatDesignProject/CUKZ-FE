//
//  SignUpView.swift
//  CUKZ
//
//  Created by 이승민 on 3/21/24.
//

import UIKit

final class SignUpView: UIView {
    // MARK: - View
    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .onDrag // 스크롤 시 키보드 숨김
    }
    
    let contentView = UIView()
    
    // 아이디
    private let idLabel = UILabel().then {
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
    
    // 중복체크
    let duplicateCheckLabel = UILabel().then {
        $0.text = "이미 사용 중인 아이디입니다."
        $0.textColor = .red
        $0.isHidden = true
    }
    
    let duplicateCheckButton = UIButton().then {
        $0.setTitle("중복체크", for: .normal)
        $0.backgroundColor = .gadaeGray
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
        $0.isSecureTextEntry = true
    }
    
    // 공백뷰
    private let spacer1 = UIView()
    
    // 2차 비밀번호
    private let secondPasswordLabel = UILabel().then() {
        $0.text = "비밀번호 재설정을 위한 2차 비밀번호"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let secondPasswordRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let secondPasswordTextField = UITextField().then {
        $0.placeholder = "2차 비밀번호를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true
    }
    
    // 공백뷰
    private let spacer2 = UIView()
    
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
    
    // 스택뷰
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    // 가입하기 버튼
    let completeButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
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
        self.addSubviews([
            scrollView,
            completeButton
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            idLabel,
            idRoundView,
            duplicateCheckLabel,
            duplicateCheckButton,
            stackView
        ])
        
        idRoundView.addSubview(idTextField)
        passwordRoundView.addSubview(passwordTextField)
        secondPasswordRoundView.addSubview(secondPasswordTextField)
        nicknameRoundView.addSubview(nicknameTextField)
        
        stackView.addArrangedSubviews([
            passwordLabel,
            passwordRoundView,
            spacer1,
//            secondPasswordLabel,
//            secondPasswordRoundView,
//            spacer2,
            nicknameLabel,
            nicknameRoundView
        ])
    }
    
    private func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.edges.equalTo(scrollView)
        }
        
        // 아이디
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
        
        // 중복체크
        duplicateCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(idRoundView.snp.bottom).offset(5)
            make.leading.equalTo(idLabel)
        }
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.top.equalTo(duplicateCheckLabel)
            make.trailing.equalTo(idLabel)
            make.height.equalTo(duplicateCheckLabel)
            make.width.equalTo(80)
        }
        
        // 스택뷰
        stackView.snp.makeConstraints { make in
            make.top.equalTo(duplicateCheckLabel.snp.bottom)
            make.leading.trailing.equalTo(idLabel)
            make.bottom.equalTo(contentView)
        }
        
        // 비밀번호
        passwordRoundView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalTo(passwordRoundView).inset(5)
        }
        
        // 구분 뷰
        spacer1.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        // 2차 비밀번호
        secondPasswordRoundView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        secondPasswordTextField.snp.makeConstraints { make in
            make.edges.equalTo(secondPasswordRoundView).inset(5)
        }
        
        // 구분 뷰
        spacer2.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        // 닉네임
        nicknameRoundView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.edges.equalTo(nicknameRoundView).inset(5)
        }
        
        // 가입하기 버튼
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
    }
}
