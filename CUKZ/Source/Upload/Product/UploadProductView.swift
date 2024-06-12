//
//  UploadProductView.swift
//  CUKZ
//
//  Created by 이승민 on 3/27/24.
//

import UIKit

final class UploadProductView: UIView {
    // MARK: - View
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let pickerView = UIPickerView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
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
    
    // 가격
    private let priceLabel = UILabel().then {
        $0.text = "가격"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let priceRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let priceTextField = UITextField().then {
        $0.placeholder = "가격을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.keyboardType = .numberPad
    }
    
    // 계좌번호
    private let accountLabel = UILabel().then {
        $0.text = "계좌번호"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let accountRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let accountTextField = UITextField().then {
        $0.placeholder = "은행과 계좌번호를 입력해주세요"
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
    
    // 시작 기간
    private let startDateLabel = UILabel().then {
        $0.text = "시작 기간"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let startDateRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let startDateTextField = UITextField().then {
        $0.placeholder = "시작 기간을 선택해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 종료 기간
    private let endDateLabel = UILabel().then {
        $0.text = "종료 기간"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let endDateRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let endDateTextField = UITextField().then {
        $0.placeholder = "종료 기간을 선택해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 상품 설명
    private let descriptionLabel = UILabel().then {
        $0.text = "상품 설명"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    let descriptionTextView = UITextView().then {
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    
    // 사진
    private let uploadImageLabel = UILabel().then {
        $0.text = "사진 (최소1장, 최대 10장)"
        $0.font = UIFont.systemFont(ofSize: 18)
        let attributedString = NSMutableAttributedString(string: $0.text ?? "")
        let range = ($0.text as NSString?)?.range(of: "(최소1장, 최대 10장)")
        if let range = range {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            $0.attributedText = attributedString
        }
    }
    
    let uploadImageView = UploadImageView()
    
    // 옵션
    private let optionLabel = UILabel().then {
        $0.text = "옵션 (최소1개, 최대 10개)"
        $0.font = UIFont.systemFont(ofSize: 18)
        let attributedString = NSMutableAttributedString(string: $0.text ?? "")
        let range = ($0.text as NSString?)?.range(of: "(최소1개, 최대 10개)")
        if let range = range {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            $0.attributedText = attributedString
        }
    }
    
    let uploadOptionView = UploadOptionView()
    
    // 공백뷰
    private let spacerView1 = UIView()
    private let spacerView2 = UIView()
    private let spacerView3 = UIView()
    private let spacerView4 = UIView()
    private let spacerView5 = UIView()
    private let spacerView6 = UIView()
    private let spacerView7 = UIView()
    private let spacerView8 = UIView()
    
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
        self.addSubviews([
            scrollView,
            completeButton
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews([
            productNameLabel,
            productNameRoundView,
            spacerView1, // 공백
            priceLabel,
            priceRoundView,
            spacerView2, // 공백
            accountLabel,
            accountRoundView,
            spacerView3, // 공백
            statusLabel,
            statusRoundView,
            spacerView4, // 공백
            startDateLabel,
            startDateRoundView,
            spacerView5, // 공백
            endDateLabel,
            endDateRoundView,
            spacerView6, // 공백
            descriptionLabel,
            descriptionTextView,
            spacerView7, // 공백
            uploadImageLabel,
            uploadImageView,
            spacerView8, //공백
            optionLabel,
            uploadOptionView
        ])
        
        productNameRoundView.addSubview(productNameTextField)
        priceRoundView.addSubview(priceTextField)
        accountRoundView.addSubview(accountTextField)
        statusRoundView.addSubview(statusTextField)
        startDateRoundView.addSubview(startDateTextField)
        endDateRoundView.addSubview(endDateTextField)
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
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
        
        [productNameRoundView, priceRoundView, accountRoundView,statusRoundView, startDateRoundView, endDateRoundView].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
        
        productNameTextField.snp.makeConstraints { make in
            make.edges.equalTo(productNameRoundView).inset(5)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.edges.equalTo(priceRoundView).inset(5)
        }
        
        accountTextField.snp.makeConstraints { make in
            make.edges.equalTo(accountRoundView).inset(5)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.edges.equalTo(statusRoundView).inset(5)
        }
        
        startDateTextField.snp.makeConstraints { make in
            make.edges.equalTo(startDateRoundView).inset(5)
        }
        
        endDateTextField.snp.makeConstraints { make in
            make.edges.equalTo(endDateRoundView).inset(5)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        uploadImageView.snp.makeConstraints { make in
            make.height.equalTo(115)
        }
        
        uploadOptionView.snp.makeConstraints { make in
            make.height.equalTo(115)
        }
        
        // 작성완료 버튼
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        // 공백뷰
        [spacerView1, spacerView2, spacerView3, spacerView4, spacerView5, spacerView6, spacerView7, spacerView8].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
    }
}
