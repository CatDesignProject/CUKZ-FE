//
//  ProductDetailView.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class ProductDetailView: UIView {
    // MARK: - View
    let scrollView = UIScrollView()
    
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
    
    private let crownIcon = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.tintColor = .gadaeGray
    }
    
    let ninknameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "닉네임"
    }
    
    private let dividerLine = UIView().then {
        $0.backgroundColor = .gadaeBlue
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        $0.attributedText = NSMutableAttributedString(string: "컴공 과잠 구매하실 분", attributes: [NSAttributedString.Key.kern: -0.6, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        $0.numberOfLines = 3
    }
    
    let priceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.text = "19000원"
    }
    
    let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        $0.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        $0.attributedText = NSMutableAttributedString(string: "대통령은 내우·외환·천재·지변 또는 중대한 재정·경제상의 위기에 있어서 국가의 안전보장 또는 공공의 안녕질서를 유지하기 위하여 긴급한 조치가 필요하고 국회의 집회를 기다릴 여유가 없을 때에 한하여 최소한으로 필요한 재정·경제상의 처분을 하거나 이에 관하여 법률의 효력을 가지는 명령을 발할 수 있다.\n\n모든 국민은 근로의 권리를 가진다. 국가는 사회적·경제적 방법으로 근로자의 고용의 증진과 적정임금의 보장에 노력하여야 하며, 법률이 정하는 바에 의하여 최저임금제를 시행하여야 한다.\n\n모든 국민은 보건에 관하여 국가의 보호를 받는다. 국가원로자문회의의 의장은 직전대통령이 된다. 다만, 직전대통령이 없을 때에는 대통령이 지명한다.", attributes: [NSAttributedString.Key.kern: -0.42, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    let purchaseDetailBottomView = ProductDetailBottomView()
    
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
                                 pageNumBackView,
                                 pageNumLabel,
                                 crownIcon,
                                 ninknameLabel,
                                 dividerLine,
                                 titleLabel,
                                 priceLabel,
                                 descriptionLabel])
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
            make.height.equalTo(30)
            make.width.equalTo(45)
            make.top.trailing.equalTo(productImageCollectionView).inset(20)
        }
        
        pageNumLabel.snp.makeConstraints { make in
            make.center.equalTo(pageNumBackView)
        }
        
        crownIcon.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(40)
            make.top.equalTo(productImageCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(contentView).inset(10)
        }
        
        ninknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(crownIcon)
            make.leading.equalTo(crownIcon.snp.trailing).offset(12)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(crownIcon.snp.bottom).offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(dividerLine)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(13)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
}
