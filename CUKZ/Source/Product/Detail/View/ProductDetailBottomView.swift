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
        $0.backgroundColor = .gadaeBlue
    }
    
    private let backgroudView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let bookmarkButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "bookmark", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .gadaeGray
    }
    
    let buyButton = UIButton().then {
        $0.backgroundColor = .gadaeBlue
        $0.setTitle("구매하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.gadaeBlue.cgColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
        self.addSubviews([dividerLine,
                          backgroudView,
                          bookmarkButton,
                          buyButton])
    }
    
    private func configureConstraints() {
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(backgroudView.snp.top)
        }
        
        backgroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(110)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(backgroudView).inset(15)
            make.leading.equalTo(backgroudView).inset(20)
        }
        
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(backgroudView).inset(18)
            make.trailing.equalTo(backgroudView).inset(20)
            make.leading.equalTo(bookmarkButton.snp.trailing).offset(10)
            make.height.equalTo(43)
        }
    }
}
