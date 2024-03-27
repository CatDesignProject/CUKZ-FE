//
//  ProductHomeCell.swift
//  CUKZ
//
//  Created by 이승민 on 3/16/24.
//

import UIKit

final class ProductHomeCell: UICollectionViewCell {
    // MARK: - View
    let backView = UIView()
    
    let thumnailImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        $0.attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.kern: -0.48, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    let priceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 1
    }
    
    let endLabel = UILabel().then {
        $0.isHidden = true
        $0.text = "판 매 종 료"
        $0.textColor = .gadaeBlue
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
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
        contentView.addSubviews([backView,
                                 endLabel])
        
        backView.addSubviews([thumnailImage,
                              titleLabel,
                              priceLabel])
    }
    
    private func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(8)
        }
        
        thumnailImage.snp.makeConstraints { make in
            make.top.equalTo(backView)
            make.leading.trailing.equalTo(backView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumnailImage.snp.bottom)
            make.leading.trailing.equalTo(backView).inset(2)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(contentView)
        }
        
        endLabel.snp.makeConstraints { make in
            make.center.equalTo(thumnailImage)
        }
        
    }
    
}
