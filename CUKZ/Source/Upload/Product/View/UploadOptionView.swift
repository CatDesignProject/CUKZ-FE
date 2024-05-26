//
//  UploadOptionView.swift
//  CUKZ
//
//  Created by 이승민 on 5/26/24.
//

import UIKit

final class UploadOptionView: UIView {
    // MARK: - View
    let addOptionButton = UIButton().then {
        $0.setTitle("옵션추가", for: .normal)
        $0.setTitleColor(.gadaeBlue, for: .normal)
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
            addOptionButton,
            collectionView,
        ])
    }
    
    private func configureConstraints() {
        addOptionButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(addOptionButton)
            make.bottom.equalTo(addOptionButton)
            make.leading.equalTo(addOptionButton.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
}

