//
//  UploadOptionCell.swift
//  CUKZ
//
//  Created by 이승민 on 5/26/24.
//

import UIKit

final class UploadOptionCell: UICollectionViewCell {
    // MARK: - View
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_delete"), for: .normal)
    }
    
    private let baseView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let optionNameLabel = UILabel().then {
        $0.text = "블랙 M"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    let additionalPrice = UILabel().then {
        $0.text = "+3000원"
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 3
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func addViews() {
        contentView.addSubviews([
            deleteButton,
            baseView,
            stackView
        ])
        
        stackView.addArrangedSubviews([
            optionNameLabel,
            additionalPrice
        ])
    }
    
    func configureConstraints() {
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.size.equalTo(30)
        }
        
        baseView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(15)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(baseView)
        }
    }
}

