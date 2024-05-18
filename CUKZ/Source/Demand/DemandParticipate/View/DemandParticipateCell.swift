//
//  DemandParticipateCell.swift
//  CUKZ
//
//  Created by 이승민 on 5/16/24.
//

import UIKit

final class DemandParticipateCell: UITableViewCell {
    // MARK: - View
    let optionNameLabel = UILabel()
    
    let quantityTextField = UITextField().then {
        $0.placeholder = "수량"
        $0.text = "0"
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
            optionNameLabel,
            quantityTextField
        ])
    }
    
    private func configureConstraints() {
        optionNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        quantityTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
    }
}
