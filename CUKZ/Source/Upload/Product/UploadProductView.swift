//
//  UploadProductView.swift
//  CUKZ
//
//  Created by 이승민 on 3/27/24.
//

import UIKit

final class UploadProductView: UIView {
    // MARK: - View
    let scrollView = UIScrollView().then {
        $0.keyboardDismissMode = .onDrag // 스크롤 시 키보드 숨김
    }
    
    private let contentView = UIView()
    
    let pickerView = UIPickerView()
    
    // 상품명
    private let productNameLabel = UILabel().then {
        $0.text = "상품명"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let productNameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let productNameTextField = UITextField().then {
        $0.placeholder = "상품명을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 상품 상태
    private let statusLabel = UILabel().then {
        $0.text = "상품 상태"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let statusRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let statusTextField = UITextField().then {
        $0.placeholder = "상품 상태를 선택해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.tintColor = .clear
    }
    
    // 종료 기간
    private let endDateLabel = UILabel().then {
        $0.text = "종료 기간 (예시 2024-03-15T12:00:00)"
        $0.font = UIFont.systemFont(ofSize: 18)
        let attributedString = NSMutableAttributedString(string: $0.text ?? "")
        let range = ($0.text as NSString?)?.range(of: "(예시 2024-03-15T12:00:00)")
        if let range = range {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            $0.attributedText = attributedString
        }
    }
    
    private let endDateRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let endDateTextField = UITextField().then {
        $0.placeholder = "2024-03-15T12:00:00"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 색상
    private let colorLabel = UILabel().then {
        $0.text = "색상 (예시 #블랙 #핑크 #네이비)"
        $0.font = UIFont.systemFont(ofSize: 18)
        let attributedString = NSMutableAttributedString(string: $0.text ?? "")
        let range = ($0.text as NSString?)?.range(of: "(예시 #블랙 #핑크 #네이비)")
        if let range = range {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            $0.attributedText = attributedString
        }
    }
    
    private let colorRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let colorTextField = UITextField().then {
        $0.placeholder = "#블랙 #핑크 #네이비"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 상품 설명
    private let desciptionLabel = UILabel().then {
        $0.text = "상품 설명"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let desciptionTextView = UITextView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    
    // 작성완료 버튼
    let completeButton = UIButton().then {
        $0.setTitle("작성완료", for: .normal)
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
        self.addSubviews([scrollView, completeButton])
        
        scrollView.addSubviews([contentView])
        
        contentView.addSubviews([productNameLabel,
                                 productNameRoundView,
                                 statusLabel,
                                 statusRoundView,
                                 endDateLabel,
                                 endDateRoundView,
                                 colorLabel,
                                 colorRoundView,
                                 desciptionLabel,
                                 desciptionTextView])
        
        productNameRoundView.addSubviews([productNameTextField])
        statusRoundView.addSubviews([statusTextField])
        endDateRoundView.addSubviews([endDateTextField])
        colorRoundView.addSubviews([colorTextField])
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
        
        // 상품명
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        productNameRoundView.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom)
            make.leading.trailing.equalTo(productNameLabel)
            make.height.equalTo(50)
        }
        
        productNameTextField.snp.makeConstraints { make in
            make.edges.equalTo(productNameRoundView).inset(5)
        }
        
        // 상품 상태
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameRoundView.snp.bottom).offset(45)
            make.leading.trailing.equalTo(productNameLabel)
        }
        
        statusRoundView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom)
            make.leading.trailing.equalTo(productNameLabel)
            make.height.equalTo(50)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.edges.equalTo(statusRoundView).inset(5)
        }
        
        // 종료 기간
        endDateLabel.snp.makeConstraints { make in
            make.top.equalTo(statusRoundView.snp.bottom).offset(45)
            make.leading.trailing.equalTo(productNameLabel)
        }
        
        endDateRoundView.snp.makeConstraints { make in
            make.top.equalTo(endDateLabel.snp.bottom)
            make.leading.trailing.equalTo(productNameLabel)
            make.height.equalTo(50)
        }
        
        endDateTextField.snp.makeConstraints { make in
            make.edges.equalTo(endDateRoundView).inset(5)
        }
        
        // 색상
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(endDateRoundView.snp.bottom).offset(45)
            make.leading.trailing.equalTo(productNameLabel)
        }
        
        colorRoundView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom)
            make.leading.trailing.equalTo(productNameLabel)
            make.height.equalTo(50)
        }
        
        colorTextField.snp.makeConstraints { make in
            make.edges.equalTo(colorRoundView).inset(5)
        }
        
        // 상품 설명
        desciptionLabel.snp.makeConstraints { make in
            make.top.equalTo(colorRoundView.snp.bottom).offset(45)
            make.leading.trailing.equalTo(productNameLabel)
        }
        
        desciptionTextView.snp.makeConstraints { make in
            make.top.equalTo(desciptionLabel.snp.bottom)
            make.leading.trailing.equalTo(productNameLabel)
            make.height.equalTo(150)
            make.bottom.equalTo(contentView).inset(100)
        }
        
        // 작성완료 버튼
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
    }
}
