//
//  LikeCell.swift
//  CUKZ
//
//  Created by 이승민 on 3/12/24.
//

import UIKit

final class LikeCell: UITableViewCell {
    // MARK: - View
    let thumnailImage = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.935, green: 0.935, blue: 0.935, alpha: 1).cgColor
        $0.contentMode = .scaleAspectFill
    }
    
    let productNameLabel = UILabel().then {
        $0.text = "컴퓨터정보공학부 과잠"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 2
    }
    
    let productPriceLabel = UILabel().then {
        $0.text = "45000원"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    let productStateLabel = UILabel().then {
        $0.text = "공동구매 중"
        $0.textColor = .purple
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private let heartIcon = UIImageView().then {
        $0.image = UIImage(systemName: "heart.fill")
        $0.tintColor = .gadaeBlue
        $0.contentMode = .scaleAspectFit
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
            thumnailImage,
            productNameLabel,
            productPriceLabel,
            productStateLabel,
            heartIcon
        ])
    }
    
    private func configureConstraints() {
        thumnailImage.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.leading.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumnailImage)
            make.leading.equalTo(thumnailImage.snp.trailing).offset(15)
            make.trailing.equalTo(heartIcon.snp.leading).inset(10)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(productNameLabel)
        }
        
        productStateLabel.snp.makeConstraints { make in
            make.leading.equalTo(productNameLabel)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        heartIcon.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalTo(thumnailImage)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
}
