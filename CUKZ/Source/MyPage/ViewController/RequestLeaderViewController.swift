//
//  RequestLeaderViewController.swift
//  CUKZ
//
//  Created by 이승민 on 6/5/24.
//

import UIKit

final class RequestLeaderViewController: UIViewController {
    // MARK: - View
    private let dismissButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gadaeBlue
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let emailRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.keyboardType = .emailAddress
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "*해당 이메일로 인증 메일을 보내드립니다.\n  해당 매일의 링크를 누르면 총대인증이 완료됩니다."
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textColor = .gadaeBlue
    }
    
    private let completeButton = UIButton().then {
        $0.setTitle("총대 신청하기", for: .normal)
        $0.backgroundColor = .lightGray
        $0.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addViews()
        configureConstraints()
        setupButton()
        
        // Add target for email validation
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
    }
    
    // MARK: - UI
    private func addViews() {
        view.addSubviews([
            dismissButton,
            emailLabel,
            emailRoundView,
            emailTextField,
            descriptionLabel,
            completeButton
        ])
    }
    
    private func configureConstraints() {
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        emailRoundView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.edges.equalTo(emailRoundView).inset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailRoundView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    private func setupButton() {
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Email Validation
    @objc private func emailTextFieldChanged() {
        if isValidEmail(emailTextField.text) {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .gadaeBlue
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = .lightGray
        }
    }
    
    private func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - Actions
extension RequestLeaderViewController {
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped() {
        guard let email = self.emailTextField.text else { return }
        self.completeButton.setTitle("전송 중...", for: .normal)
        self.dismissButton.isHidden = true
        
        UserNetworkManager.shared.postRequestLeader(email: email) { error in
            if let error = error {
                print("총대 인증 이메일 전송 실패 - \(error.localizedDescription)")
            } else {
                print("총대 인증 이메일 전송 성공")
                self.dismiss(animated: true, completion: nil)
                self.showAlertWithDismissDelay(message: "이메일 전송이 완료되었습니다.")
            }
        }
    }
}
