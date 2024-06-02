//
//  DemandParticipateView.swift
//  CUKZ
//
//  Created by 이승민 on 5/16/24.
//

import UIKit

final class DemandParticipateView: UIView {
    // MARK: - View
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let emailRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    let quantityLabel = UILabel().then {
        $0.text = "수량"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let tableView = UITableView().then {
        $0.separatorInset.left = 20
        $0.separatorInset.right = 20
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("수요조사 참여하기", for: .normal)
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
            emailLabel,
            emailRoundView,
            emailTextField,
            quantityLabel,
            tableView,
            completeButton
        ])
    }
    
    private func configureConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
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
        
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(emailRoundView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
