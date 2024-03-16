//
//  PurchaseDetailView.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class PurchaseDetailView: UIView {
    // MARK: - View
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let flowlayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal // 가로 스크롤
    }
    
    lazy var productImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout).then {
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true // 페이징
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let pageNumBackView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.2) // 투명도 조정
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
    }
    
    let pageNumLabel = UILabel().then {
        $0.text = "1 / 5"
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 17)
    }
    
    let testLabel = UILabel().then {
        $0.text = "테\n스\n트\n테\n스\n트\n테\n스\n트\n테\n스\n트\n테\n스\n트\n테\n스\n트\n테\n스\n트\n"
        $0.numberOfLines = 0
    }
    
    let purchaseDetailBottomView = PurchaseDetailBottomView()
    
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
        self.addSubviews([scrollView,
                          purchaseDetailBottomView])
        
        scrollView.addSubviews([contentView])
        
        contentView.addSubviews([productImageCollectionView,
                                 testLabel,
                                 pageNumBackView,
                                 pageNumLabel])
    }
    
    private func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(purchaseDetailBottomView.snp.top)
        }
        
        purchaseDetailBottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(110)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.edges.equalTo(scrollView)
        }
        
        productImageCollectionView.snp.makeConstraints { make in
            make.height.equalTo(375)
            make.top.leading.trailing.equalTo(contentView)
        }
        
        pageNumBackView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalTo(50)
            make.top.trailing.equalTo(productImageCollectionView).inset(20)
        }
        
        pageNumLabel.snp.makeConstraints { make in
            make.center.equalTo(pageNumBackView)
        }
        
        testLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
            make.top.equalTo(productImageCollectionView.snp.bottom).offset(30)
        }
    }
}
