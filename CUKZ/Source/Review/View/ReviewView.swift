//
//  ReviewView.swift
//  CUKZ
//
//  Created by 이승민 on 4/5/24.
//

import UIKit

final class ReviewView: UIView {
    // MARK: - View
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임 님의\n이런 점이 좋았어요"
        $0.font = .boldSystemFont(ofSize: 25)
        $0.numberOfLines = 2
    }
    
    // 1
    let firstQuestionView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let firstQuestionButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.tag = 1
    }
    
    private let firstQuestionLabel = UILabel().then {
        $0.text = "친절해요"
    }
    
    let firstQuestionNumLabel = UILabel().then {
        $0.text = "24"
    }
    
    // 2
    let secondQuestionView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let secondQuestionButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.tag = 2
    }
    
    private let secondQuestionLabel = UILabel().then {
        $0.text = "진행상황 공지를 잘해줘요"
    }
    
    let secondQuestionNumLabel = UILabel().then {
        $0.text = "7"
    }
    
    // 3
    let thirdQuestionView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let thirdQuestionButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.tag = 3
    }
    
    private let thirdQuestionLabel = UILabel().then {
        $0.text = "상품 설명과 수령한 상품이 동일해요"
    }
    
    let thirdQuestionNumLabel = UILabel().then {
        $0.text = "88"
    }
    
    // 4
    let fourthQuestionView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    let fourthQuestionButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.tag = 4
    }
    
    private let fourthQuestionLabel = UILabel().then {
        $0.text = "상품이 잘 도착했어요"
    }
    
    let fourthQuestionNumLabel = UILabel().then {
        $0.text = "5"
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("리뷰하기", for: .normal)
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
            stackView,
            completeButton
        ])
        
        stackView.addArrangedSubviews([
            nicknameLabel,
            firstQuestionView,
            secondQuestionView,
            thirdQuestionView,
            fourthQuestionView
        ])
        
        firstQuestionView.addSubviews([
            firstQuestionLabel,
            firstQuestionNumLabel,
            firstQuestionButton])
        
        secondQuestionView.addSubviews([
            secondQuestionLabel,
            secondQuestionNumLabel,
            secondQuestionButton
        ])
        
        thirdQuestionView.addSubviews([
            thirdQuestionLabel,
            thirdQuestionNumLabel,
            thirdQuestionButton
        ])
        
        fourthQuestionView.addSubviews([
            fourthQuestionLabel,
            fourthQuestionNumLabel,
            fourthQuestionButton
        ])
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        // 1
        firstQuestionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        firstQuestionButton.snp.makeConstraints { make in
            make.edges.equalTo(firstQuestionView)
        }
        
        firstQuestionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstQuestionView)
            make.leading.equalTo(firstQuestionView).inset(10)
        }
        
        firstQuestionNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstQuestionView)
            make.trailing.equalTo(firstQuestionView).inset(10)
        }
        
        // 2
        secondQuestionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        secondQuestionButton.snp.makeConstraints { make in
            make.edges.equalTo(secondQuestionView)
        }
        
        secondQuestionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(secondQuestionView)
            make.leading.equalTo(secondQuestionView).inset(10)
        }
        
        secondQuestionNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(secondQuestionView)
            make.trailing.equalTo(secondQuestionView).inset(10)
        }
        
        // 3
        thirdQuestionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        thirdQuestionButton.snp.makeConstraints { make in
            make.edges.equalTo(thirdQuestionView)
        }
        
        thirdQuestionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thirdQuestionView)
            make.leading.equalTo(thirdQuestionView).inset(10)
        }
        
        thirdQuestionNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(thirdQuestionView)
            make.trailing.equalTo(thirdQuestionView).inset(10)
        }
        
        // 4
        fourthQuestionView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        fourthQuestionButton.snp.makeConstraints { make in
            make.edges.equalTo(fourthQuestionView)
        }
        
        fourthQuestionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fourthQuestionView)
            make.leading.equalTo(fourthQuestionView).inset(10)
        }
        
        fourthQuestionNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fourthQuestionView)
            make.trailing.equalTo(fourthQuestionView).inset(10)
        }
        
        // 리뷰하기
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
