//
//  UploadImageCell.swift
//  CUKZ
//
//  Created by 이승민 on 5/24/24.
//

import UIKit

final class UploadImageCell: UICollectionViewCell {
    // MARK: - View
    let uploadedImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = UIImage(named: "testImage2")
    }
    
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_delete"), for: .normal)
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
            uploadedImageView,
            deleteButton
        ])
    }
    
    func configureConstraints() {
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        uploadedImageView.snp.makeConstraints {
            $0.leading.bottom.equalTo(contentView)
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
