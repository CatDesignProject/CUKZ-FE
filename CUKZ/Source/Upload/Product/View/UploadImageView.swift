//
//  UploadImageView.swift
//  CUKZ
//
//  Created by 이승민 on 5/24/24.
//

import UIKit

final class UploadImageView: UIView {
    // MARK: - View
    let addImageButton = UIButton().then {
        $0.tintColor = .gadaeBlue
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let flowlayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 100, height: 100)
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)

    
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
            addImageButton,
            collectionView,
        ])
    }
    
    private func configureConstraints() {
        addImageButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(addImageButton)
            make.bottom.equalTo(addImageButton).inset(5)
            make.leading.equalTo(addImageButton.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
}
