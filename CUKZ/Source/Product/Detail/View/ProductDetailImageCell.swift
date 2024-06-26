//
//  ProductDetailImageCell.swift
//  CUKZ
//
//  Created by 이승민 on 3/15/24.
//

import UIKit

final class ProductDetailImageCell: UICollectionViewCell {
    // MARK: - View
    let mainImage = UIImageView().then {
        $0.image = UIImage(named: "testImage2")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
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
        contentView.addSubview(mainImage)
    }
    
    private func configureConstraints() {
        mainImage.snp.makeConstraints { make in
            make.height.equalTo(375)
            make.edges.equalTo(contentView)
        }
    }
    
}
