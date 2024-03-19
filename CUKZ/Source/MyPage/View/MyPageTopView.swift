//
//  MyPageTopView.swift
//  CUKZ
//
//  Created by 이승민 on 3/18/24.
//

import UIKit

final class MyPageTopView: UIView {
    // MARK: - View
    private let backView = UIView()
    
    let nicknameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    let leaderLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    let requestLeaderButton = UIButton().then {
        $0.setTitle("총대 신청하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.backgroundColor = .gadaeGray
    }
    
    let dividerLine = UIView().then {
        $0.backgroundColor = .gadaeBlue
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        self.addSubviews([backView,
                          nicknameLabel,
                          leaderLabel,
                          requestLeaderButton,
                          dividerLine])
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(20)
            make.centerX.equalTo(backView)
        }
        
        leaderLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(backView)
        }
        
        requestLeaderButton.snp.makeConstraints { make in
            make.top.equalTo(leaderLabel.snp.bottom).offset(20)
            make.centerX.equalTo(backView)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(backView)
            make.bottom.equalTo(backView)
        }
    }
}
