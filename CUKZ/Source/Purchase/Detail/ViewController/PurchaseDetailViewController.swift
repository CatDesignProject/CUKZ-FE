//
//  PurchaseDetailViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class PurchaseDetailViewController: UIViewController {
    // MARK: - Properties
    private var isBookmark = false
    
    private let purchaseDetailView = PurchaseDetailView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseDetailView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupImageCollectionView()
        setupScrollView()
        setupButton()
    }
    
    private func prepare() {
        title = "구매하기"
    }
    
    private func setupScrollView() {
        purchaseDetailView.scrollView.delegate = self
    }
    
    private func setupImageCollectionView() {
        let imageCV = purchaseDetailView.productImageCollectionView
        imageCV.delegate = self
        imageCV.dataSource = self
        imageCV.register(PurchaseDetailImageCell.self, forCellWithReuseIdentifier: "PurchaseDetailImageCell")
    }
    
    private func setupButton() {
        purchaseDetailView.purchaseDetailBottomView.bookmarkButton.addTarget(nil, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        purchaseDetailView.purchaseDetailBottomView.buyButton.addTarget(nil, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
    
    @objc func bookmarkButtonTapped() {
        isBookmark.toggle()
        
        let systemName = isBookmark ? "bookmark" : "bookmark.fill"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        
        purchaseDetailView.purchaseDetailBottomView.bookmarkButton.setImage(image, for: .normal)
    }
    
    @objc func buyButtonTapped() {
        print("구매하기 버튼 눌림")
    }
    
}

// MARK: - UIScrollViewDelegate
extension PurchaseDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == purchaseDetailView.productImageCollectionView {
            let index = Int(scrollView.contentOffset.x / purchaseDetailView.productImageCollectionView.bounds.width)
            purchaseDetailView.pageNumLabel.text = "\(index + 1) / 5"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PurchaseDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseDetailImageCell", for: indexPath) as! PurchaseDetailImageCell
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PurchaseDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
