//
//  ProductDetailView.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class ProductDetailView: UIView {
    // MARK: - View
    let refreshControl = UIRefreshControl()
    
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
    
    private let personIcon = UIImageView().then {
        $0.image = UIImage(systemName: "person.badge.shield.checkmark.fill")
        $0.tintColor = .gadaeBlue
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "이곳은닉네임라벨"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    let reviewButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("총대 리뷰보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 10)
    }
    
    private let dividerLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let productNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 23)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        $0.attributedText = NSMutableAttributedString(string: "컴공 과잠 구매하실 분", attributes: [NSAttributedString.Key.kern: -0.6, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        $0.numberOfLines = 3
    }
    
    let productPriceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.text = "19000원"
    }
    
    let productDescriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.25
        $0.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        $0.attributedText = NSMutableAttributedString(string: "대통령은 내우·외환·천재·지변 또는 중대한 재정·경제상의 위기에 있어서 ", attributes: [NSAttributedString.Key.kern: -0.42, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    let productDetailBottomView = ProductDetailBottomView()
    
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
                          productDetailBottomView])
        
        scrollView.addSubviews([contentView])
        
        contentView.addSubviews([
            productImageCollectionView,
            pageNumBackView,
            pageNumLabel,
            personIcon,
            nicknameLabel,
            reviewButton,
            dividerLine,
            productNameLabel,
            productPriceLabel,
            productDescriptionLabel
        ])
    }
    
    private func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(productDetailBottomView.snp.top)
        }
        
        productDetailBottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
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
        
        personIcon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(productImageCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(contentView).inset(10)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(personIcon)
            make.leading.equalTo(personIcon.snp.trailing).offset(12)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nicknameLabel).offset(1)
            make.height.equalTo(UIFont.systemFont(ofSize: 10).lineHeight) // 글씨 높이 만큼
        }
        
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.top.equalTo(personIcon.snp.bottom).offset(10)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(dividerLine)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(productNameLabel)
        }
        
        productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceLabel.snp.bottom).offset(13)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
}
