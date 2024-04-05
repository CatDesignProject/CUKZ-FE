//
//  ProductDetailBottomView.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class ProductDetailBottomView: UIView {
    // MARK: - View
    private let dividerLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let likeButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .gadaeBlue
    }
    
    let stateButton = UIButton().then {
        $0.backgroundColor = .gadaeGray
        $0.setTitle("수요조사 참여하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.layer.cornerRadius = 8
    }
    
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
            dividerLine,
            likeButton,
            stateButton
        ])
    }
    
    private func configureConstraints() {
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        stateButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
            make.height.equalTo(43)
        }
    }
}
