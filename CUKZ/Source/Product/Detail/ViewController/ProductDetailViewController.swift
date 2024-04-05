//
//  ProductDetailViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    private var isLike = false
    
    private let productDetailView = ProductDetailView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productDetailView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupNaviBar()
        setupScrollView()
        setupImageCollectionView()
        setupButton()
    }
    
    private func prepare() {
        
    }
    
    private func setupNaviBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupScrollView() {
        productDetailView.scrollView.delegate = self
    }
    
    private func setupImageCollectionView() {
        let imageCV = productDetailView.productImageCollectionView
        imageCV.delegate = self
        imageCV.dataSource = self
        imageCV.register(ProductDetailImageCell.self, forCellWithReuseIdentifier: "ProductDetailImageCell")
    }
    
    private func setupButton() {
        productDetailView.nicknameButton.addTarget(self, action: #selector(nicknameButtonTapped), for: .touchUpInside)
        productDetailView.productDetailBottomView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        productDetailView.productDetailBottomView.stateButton.addTarget(self, action: #selector(stateButtonTapped), for: .touchUpInside)
    }
    
}

// MARK: - @objc
extension ProductDetailViewController {
    @objc func nicknameButtonTapped() {
        let VC = ReviewViewController()
        VC.isLeave = false
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func likeButtonTapped() {
        isLike.toggle()
        
        let systemName = isLike ? "heart.fill" : "heart"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        
        productDetailView.productDetailBottomView.likeButton.setImage(image, for: .normal)
    }
    
    @objc func stateButtonTapped() {
        print("상품 상태 버튼 눌림")
    }
}

// MARK: - UIScrollViewDelegate
extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productDetailView.productImageCollectionView {
            let index = Int(scrollView.contentOffset.x / productDetailView.productImageCollectionView.bounds.width)
            productDetailView.pageNumLabel.text = "\(index + 1) / 5"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCell", for: indexPath) as! ProductDetailImageCell
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    
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
