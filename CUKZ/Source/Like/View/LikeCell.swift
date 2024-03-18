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
        $0.text = "53000원"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    let bookmarkButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .gadaeGray
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        contentView.addSubviews([thumnailImage,
                                 productNameLabel,
                                 productPriceLabel,
                                 bookmarkButton])
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
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-10)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(productNameLabel)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(thumnailImage)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
}
