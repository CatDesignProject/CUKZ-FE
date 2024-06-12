//
//  PurchaseManagerCell.swift
//  CUKZ
//
//  Created by 이승민 on 6/13/24.
//

import UIKit

final class PurchaseManagerCell: UITableViewCell {
    // MARK: - View
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let buyerNameLabel = UILabel().then {
        $0.text = "홍길동"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 2
    }
    
    let buyerPhoneLabel = UILabel().then {
        $0.text = "01033337777"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    let totalPriceLabel = UILabel().then {
        $0.text = "53000원"
        $0.textColor = .gadaeBlue
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    let checkIcon = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.square.fill")
        $0.tintColor = .systemGreen
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        contentView.addSubviews([
            stackView,
            checkIcon
        ])
        
        stackView.addArrangedSubviews([
            buyerNameLabel,
            buyerPhoneLabel,
            totalPriceLabel
        ])
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(checkIcon.snp.leading)
        }
        
        checkIcon.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
            make.size.equalTo(35)
        }
    }
}

