//
//  PurchaseParticipateTopView.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class PurchaseParticipateTopView: UIView {
    // MARK: - View
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    // 구매자
    private let buyerNameLabel = UILabel().then {
        $0.text = "구매자"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let buyerNameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let buyerNameTextField = UITextField().then {
        $0.placeholder = "구매자 이름을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 구매자 전화번호
    private let buyerPhoneLabel = UILabel().then {
        $0.text = "구매자 전화번호"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let buyerPhoneRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let buyerPhoneTextField = UITextField().then {
        $0.placeholder = "구매자 전화번호를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.keyboardType = .numberPad
    }
    
    // 수령인
    private let recipientNameLabel = UILabel().then {
        $0.text = "수령인"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let recipientNameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let recipientNameTextField = UITextField().then {
        $0.placeholder = "수령인 이름을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.tintColor = .clear
    }
    
    // 수령인 전화번호
    private let recipientPhoneLabel = UILabel().then {
        $0.text = "수령인 전화번호"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let recipientPhoneRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let recipientPhoneTextField = UITextField().then {
        $0.placeholder = "수령인 전화번호를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.keyboardType = .numberPad
    }
    
    // 주소
    private let addressLabel = UILabel().then {
        $0.text = "주소"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let addressRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let addressTextField = UITextField().then {
        $0.placeholder = "주소를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 입금자
    private let payerNameLabel = UILabel().then {
        $0.text = "입급자"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let payerNameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let payerNameTextfield = UITextField().then {
        $0.placeholder = "입급자 이름을 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 환불 계좌주
    private let refundNameLabel = UILabel().then {
        $0.text = "환불 계좌주"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let refundNameRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let refundNameTextfield = UITextField().then {
        $0.placeholder = "환불 계좌주를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 환불 계좌
    private let refundAccountLabel = UILabel().then {
        $0.text = "환불 계좌"
        $0.font = UIFont.systemFont(ofSize: 18)
    }
    
    private let refundAccountRoundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
    }
    
    let refundAccountTextfield = UITextField().then {
        $0.placeholder = "환불 계좌를 입력해주세요"
        $0.backgroundColor = .clear
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.font = UIFont.systemFont(ofSize: 19)
    }
    
    // 공백뷰
    private let spacerView1 = UIView()
    private let spacerView2 = UIView()
    private let spacerView3 = UIView()
    private let spacerView4 = UIView()
    private let spacerView5 = UIView()
    private let spacerView6 = UIView()
    private let spacerView7 = UIView()
    
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
            stackView
        ])
        
        stackView.addArrangedSubviews([
            buyerNameLabel,
            buyerNameRoundView,
            spacerView1,
            
            buyerPhoneLabel,
            buyerPhoneRoundView,
            spacerView2,
            
            recipientNameLabel,
            recipientNameRoundView,
            spacerView3,
            
            recipientPhoneLabel,
            recipientPhoneRoundView,
            spacerView4,
            
            addressLabel,
            addressRoundView,
            spacerView5,
            
            payerNameLabel,
            payerNameRoundView,
            spacerView6,
            
            refundNameLabel,
            refundNameRoundView,
            spacerView7,
            
            refundAccountLabel,
            refundAccountRoundView,
        ])
        
        buyerNameRoundView.addSubview(buyerNameTextField)
        buyerPhoneRoundView.addSubview(buyerPhoneTextField)
        recipientNameRoundView.addSubview(recipientNameTextField)
        recipientPhoneRoundView.addSubview(recipientPhoneTextField)
        addressRoundView.addSubview(addressTextField)
        payerNameRoundView.addSubview(payerNameTextfield)
        refundNameRoundView.addSubview(refundNameTextfield)
        refundAccountRoundView.addSubview(refundAccountTextfield)
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        [buyerNameRoundView, buyerPhoneRoundView, recipientNameRoundView, recipientPhoneRoundView, addressRoundView, payerNameRoundView, refundNameRoundView, refundAccountRoundView].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
        
        buyerNameTextField.snp.makeConstraints { make in
            make.edges.equalTo(buyerNameRoundView).inset(5)
        }
        
        buyerPhoneTextField.snp.makeConstraints { make in
            make.edges.equalTo(buyerPhoneRoundView).inset(5)
        }
        
        recipientNameTextField.snp.makeConstraints { make in
            make.edges.equalTo(recipientNameRoundView).inset(5)
        }
        
        recipientPhoneTextField.snp.makeConstraints { make in
            make.edges.equalTo(recipientPhoneRoundView).inset(5)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.edges.equalTo(addressRoundView).inset(5)
        }
        
        payerNameTextfield.snp.makeConstraints { make in
            make.edges.equalTo(payerNameRoundView).inset(5)
        }
        
        refundNameTextfield.snp.makeConstraints { make in
            make.edges.equalTo(refundNameRoundView).inset(5)
        }
        
        refundAccountTextfield.snp.makeConstraints { make in
            make.edges.equalTo(refundAccountRoundView).inset(5)
        }
        
        [spacerView1, spacerView2, spacerView3, spacerView4, spacerView5, spacerView6, spacerView7].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}
