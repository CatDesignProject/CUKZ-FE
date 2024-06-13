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
        setupScrollView()
        setupRefresh()
        setupImageCollectionView()
        setupButton()
    }
    
    func fetchData() {
        guard let productId = self.productId else { return }
        ProductNetworkManager.shared.getProductDetail(productId: productId) { model in
            self.productDetailData = model
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        setupNaviBar()
        
        productDetailView.productImageCollectionView.reloadData()
        
        guard let data = self.productDetailData else { return }
        
        // 사진 맨앞장으로
        let indexPath = IndexPath(item: 0, section: 0)
        self.productDetailView.productImageCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        
        // 좋아요
        self.isLiked = data.isLiked
        
        // 상품상태
        var productStatus: String = ""
        var productStatusColor: UIColor = .systemGray
        
        switch data.status {
        case "ON_DEMAND":
            productStatus = "수요조사 참여하기"
            productStatusColor = .systemPink
        case "END_DEMAND":
            productStatus = "수요조사 종료"
        case "ON_SALE":
            productStatus = "구매하기"
            productStatusColor = .systemBlue
        case "END_SALE":
            productStatus = "판매 종료"
        case "COMPLETE":
            productStatus = "공구 종료"
        default:
            return
        }
        
        productDetailView.pageNumLabel.text = "1 / \(data.imageUrls.count)"
        productDetailView.nicknameLabel.text = data.nickname
        productDetailView.accountLabel.text = data.sellerAccount
        productDetailView.dateLabel.text = "기간: \(formatDate(data.startDate)) ~ \(formatDate(data.endDate))"
        productDetailView.productNameLabel.text = data.name
        productDetailView.productPriceLabel.text = "\(data.price)원"
        productDetailView.productDescriptionLabel.text = data.info
        
        updateLikeButtonAppearance()
        productDetailView.productDetailBottomView.statusButton.setTitle(productStatus, for: .normal)
        productDetailView.productDetailBottomView.statusButton.backgroundColor = productStatusColor
        
        func formatDate(_ dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = inputFormatter.date(from: dateString) else {
                return dateString
            }
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        }
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        guard let sellerId = self.productDetailData?.sellerId else { return }
        
        if AppDelegate.memberId == sellerId {
            let docButton = UIButton().then {
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .light)
                let image = UIImage(systemName: "list.clipboard", withConfiguration: imageConfig)
                $0.setImage(image, for: .normal)
                $0.addTarget(self, action: #selector(gearButtonTapped), for: .touchUpInside)
            }
            
            let menuButton = UIButton().then {
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
                let image = UIImage(systemName: "ellipsis.circle", withConfiguration: imageConfig)
                $0.setImage(image, for: .normal)
                $0.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            }
            
            
            let itemsStackView = UIStackView.init(arrangedSubviews: [docButton, menuButton])
            itemsStackView.distribution = .fillEqually
            itemsStackView.axis = .horizontal
            itemsStackView.alignment = .center
            itemsStackView.spacing = 12
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: itemsStackView) // 오른쪽
        }
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
    
    // 하트 이미지 설정
    private func updateLikeButtonAppearance() {
        let systemName = self.isLiked ? "heart.fill" : "heart"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        productDetailView.productDetailBottomView.likeButton.setImage(image, for: .normal)
    }
}

// MARK: - @objc
extension ProductDetailViewController {
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
    
    // 수요조사, 구매 인원 보기
    @objc private func gearButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let demandAction = UIAlertAction(title: "수요조사 참여 인원 수", style: .default) {_ in
            let VC = DemandCountViewController()
            VC.productId = self.productId
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        let purchaseAction = UIAlertAction(title: "구매하기한 인원 목록", style: .default) {_ in
            let VC = PurchaseManagerViewController()
            VC.productId = self.productId
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [demandAction, purchaseAction, cancelAction].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 메뉴
    @objc private func menuButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) {_ in
            let sheet = UIAlertController(title: nil, message: "삭제 하시겠습니까?", preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "취소", style: .destructive))
            sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                if let productId = self.productDetailData?.id {
                    ProductNetworkManager.shared.deleteProduct(productId: productId) { error in
                        if let error = error {
                            print("상품 삭제 실패: \(error.localizedDescription)")
                            self.showAlertWithDismissDelay(message: "수요조사 종료 및 판매 종료 상품은 삭제할 수 없습니다.")
                        } else {
                            print("상품 삭제 성공")
                            if let productHomeVC = self.navigationController?.viewControllers.first(where: { $0 is ProductHomeViewController }) as? ProductHomeViewController {
                                self.navigationController?.popViewController(animated: true)
                                productHomeVC.fetchData()
                            }
                        }
                    }
                }
            }))
            self.present(sheet, animated: true)
        }
        
        let patchAction = UIAlertAction(title: "수정하기", style: .default) {_ in 
            let VC = UploadProductViewController()
            guard let productId = self.productId,
                  let data = self.productDetailData else { return }
            
            VC.isPatch = true
            VC.productId = productId
            VC.uploadProductView.productNameTextField.text = data.name
            VC.uploadProductView.priceTextField.text = String(data.price)
            VC.uploadProductView.accountTextField.text = data.sellerAccount
            
            switch data.status {
            case "ON_DEMAND" :
                VC.uploadProductView.statusTextField.text = "수요조사 중"
            case "END_DEMAND" :
                VC.uploadProductView.statusTextField.text = "수요조사 종료"
            case "ON_SALE":
                VC.uploadProductView.statusTextField.text = "판매 중"
            case "END_SALE":
                VC.uploadProductView.statusTextField.text = "판매 종료"
            default:
                return
            }
            
            // "yyyy-MM-dd" 형식으로 변환하여
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let startDate = dateFormatter.date(from: data.startDate)
            let endDate = dateFormatter.date(from: data.endDate)
            
            if let startDate = startDate, let endDate = endDate {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                VC.uploadProductView.startDateTextField.text = dateFormatter.string(from: startDate)
                VC.uploadProductView.endDateTextField.text = dateFormatter.string(from: endDate)
            }
            
            VC.uploadProductView.descriptionTextView.text = data.info
            
            // 이미지 URL 배열을 반복하면서 이미지를 다운로드하여 배열에 추가
            for imageUrl in data.imageUrls {
                guard let url = URL(string: imageUrl) else { continue }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        // 이미지를 다운로드하고 배열에 추가
                        VC.imageList.append(image)
                        // 이미지를 다운로드한 후에는 컬렉션 뷰를 다시 로드하여 업데이트
                        DispatchQueue.main.async {
                            VC.uploadProductView.uploadImageView.collectionView.reloadData()
                        }
                    }
                }.resume()
            }
            
            VC.optionList = data.options.map { UploadProductRequest.Options(from: $0) }
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [deleteAction, patchAction, cancelAction].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 총대 리뷰보기
    @objc func reviewButtonTapped() {
        let VC = ReviewViewController()
        VC.isLeave = false
        VC.sellerId = self.productDetailData?.sellerId
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 좋아요
    @objc func likeButtonTapped() {
        if AppDelegate.isLogin {
            self.isLiked.toggle()
            updateLikeButtonAppearance()
            
            if let productId = productId {
                if isLiked {
                    LikeNetworkManager.shared.postLike(productId: productId)
                } else {
                    LikeNetworkManager.shared.postUnlike(productId: productId)
                }
            }
        } else {
            showAlertWithDismissDelay(message: "로그인 후 이용해주세요.")
        }
    }
    
    // 수요조사 참여, 구매하기
    @objc func statusButtonTapped() {
        guard let data = self.productDetailData,
              let productId = self.productId else { return }
        
        if !AppDelegate.isLogin  {
            showAlertWithDismissDelay(message: "로그인 후 이용해주세요.")
            return
        } else if AppDelegate.memberId == data.sellerId {
            showAlertWithDismissDelay(message: "내가 작성한 글입니다.")
            return
        }
        
        switch data.status {
        case "ON_DEMAND": // 수요조사 참여
            let VC = DemandParticipateViewController()
            VC.optionList = data.options
            VC.productId = productId
            navigationController?.pushViewController(VC, animated: true)
        case "ON_SALE": // 구매하기
            let VC = PurchaseParticipateOptionViewController()
            VC.optionList = data.options
            VC.productId = productId
            navigationController?.pushViewController(VC, animated: true)
        default:
            showAlertWithDismissDelay(message: "종료되었습니다.")
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productDetailView.productImageCollectionView {
            let index = Int(scrollView.contentOffset.x / productDetailView.productImageCollectionView.bounds.width)
            productDetailView.pageNumLabel.text = "\(index + 1) / \(self.productDetailData?.imageUrls.count ?? 0)"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productDetailData?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCell", for: indexPath) as! ProductDetailImageCell
        
        if let imageUrlString = self.productDetailData?.imageUrls[indexPath.item] {
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
