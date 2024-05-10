//
//  ProductDetailViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/13/24.
//

import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    var productId: Int?
    
    private var isLiked = false
    private var productDetailData: ProductDetailModel?
    
    private let productDetailView = ProductDetailView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productDetailView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupNaviBar()
        setupScrollView()
        setupRefresh()
        setupImageCollectionView()
        setupButton()
    }
    
    private func fetchData() {
        guard let productId = self.productId else { return }
        ProductNetworkManager.shared.getProductDetail(productId: productId) { model in
            self.productDetailData = model
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        productDetailView.productImageCollectionView.reloadData()
        guard let data = self.productDetailData else { return }
        
        let productStatus: String
        switch data.body.status {
        case "ON_DEMAND":
            productStatus = "수요조사 참여하기"
        case "END_DEMAND":
            productStatus = "수요조사 종료"
        case "ON_SALE":
            productStatus = "구매하기"
        case "END_SALE":
            productStatus = "판매 종료"
        default:
            productStatus = ""
        }
        
        productDetailView.pageNumLabel.text = "1 / \(data.body.imageUrls.count)"
        productDetailView.nicknameLabel.text = data.body.nickname
        productDetailView.productNameLabel.text = data.body.name
        productDetailView.productPriceLabel.text = "\(data.body.price)원"
        productDetailView.productDescriptionLabel.text = data.body.info
        productDetailView.productDetailBottomView.statusButton.setTitle(productStatus, for: .normal)
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupScrollView() {
        productDetailView.scrollView.delegate = self
    }
    
    // 새로고침 설정
    private func setupRefresh() {
        let rc = productDetailView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        productDetailView.scrollView.refreshControl = rc
    }
    
    private func setupImageCollectionView() {
        let imageCV = productDetailView.productImageCollectionView
        imageCV.delegate = self
        imageCV.dataSource = self
        imageCV.register(ProductDetailImageCell.self, forCellWithReuseIdentifier: "ProductDetailImageCell")
    }
    
    private func setupButton() {
        productDetailView.reviewButton.addTarget(self,
                                                 action: #selector(reviewButtonTapped),
                                                 for: .touchUpInside)
        
        productDetailView.productDetailBottomView.likeButton.addTarget(self,
                                                                       action: #selector(likeButtonTapped),
                                                                       for: .touchUpInside)
        
        productDetailView.productDetailBottomView.statusButton.addTarget(self,
                                                                        action: #selector(statusButtonTapped),
                                                                        for: .touchUpInside)
    }
}

// MARK: - @objc
extension ProductDetailViewController {
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            
            // refresh된 후 첫 번째 셀로 이동
            if let productDetailData = self.productDetailData, !productDetailData.body.imageUrls.isEmpty {
                let indexPath = IndexPath(item: 0, section: 0)
                self.productDetailView.productImageCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
            
            refresh.endRefreshing()
        }
    }
    
    // 총대 리뷰보기
    @objc func reviewButtonTapped() {
        let VC = ReviewViewController()
        VC.isLeave = false
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 좋아요
    @objc func likeButtonTapped() {
        isLiked.toggle()
        
        let systemName = isLiked ? "heart.fill" : "heart"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        
        productDetailView.productDetailBottomView.likeButton.setImage(image, for: .normal)
    }
    
    @objc func statusButtonTapped() {
        print("상품 상태 버튼 눌림")
    }
}

// MARK: - UIScrollViewDelegate
extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productDetailView.productImageCollectionView {
            let index = Int(scrollView.contentOffset.x / productDetailView.productImageCollectionView.bounds.width)
            productDetailView.pageNumLabel.text = "\(index + 1) / \(self.productDetailData?.body.imageUrls.count ?? 0)"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetailData?.body.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCell", for: indexPath) as! ProductDetailImageCell
        
        if let imageUrlString = self.productDetailData?.body.imageUrls[indexPath.item] {
            if let imageUrl = URL(string: imageUrlString) {
                cell.mainImage.kf.setImage(with: imageUrl)
            }
        }
        
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
