//
//  PurchseHomeViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/16/24.
//

import UIKit
import Kingfisher

final class ProductHomeViewController: UIViewController {
    // MARK: - Properties
    private var arrayProduct: [ProductHomeModel.Content] = []
    private var totalPageNum: Int = 0
    private var pageNum: Int = 0
    private var isLastPage: Bool = false
    private var keyword: String?
    
    var isMyproduct: Bool = false
    
    private let productHomeView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productHomeView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupNaviBar()
        setupTableView()
        setupRefresh()
    }
    
    // 네트워킹
    func fetchData() {
        self.pageNum = 0
        
        if isMyproduct {
            ProductNetworkManager.shared.getMyProductAll(page: 0) { result in
                switch result {
                case .success(let data):
                    print("내가 등록한 상품 목록 전체 조회 성공")
                    guard let data = data else { return }
                    
                    self.totalPageNum = data.totalPage
                    self.isLastPage = data.last
                    self.arrayProduct = data.content
                    DispatchQueue.main.async {
                        self.productHomeView.tableView.reloadData()
                    }
                case .failure(let error):
                    print("내가 등록한 상품 목록 전체 조회 실패: \(error.localizedDescription)")
                }
            }
        } else {
            ProductNetworkManager.shared.getProductAll(page: 0) { model in
                if let model = model {
                    self.totalPageNum = model.totalPage
                    self.isLastPage = model.last
                    self.arrayProduct = model.content
                    DispatchQueue.main.async {
                        self.productHomeView.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // 네비게이션바 설정
    private func setupNaviBar() {
        title = isMyproduct ? "내가 작성한 상품" : "상품"
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .gadaeBlue
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        guard isMyproduct == false else { return }
        
        // leftBarButtonItem, rightBarButtonItem 스택뷰 커스텀
        let uploadButton = UIButton().then {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
            let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
            $0.setImage(image, for: .normal)
            $0.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        }
        
        let searchButton = UIButton().then {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .light)
            let image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)
            $0.setImage(image, for: .normal)
            $0.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
        
//        let menuButton = UIButton().then {
//            let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
//            let image = UIImage(systemName: "ellipsis.circle", withConfiguration: imageConfig)
//            $0.setImage(image, for: .normal)
//            
//            let on_demand = UIAction(title: "수요조사 중", image: nil, handler: { _ in print("수요조사 중") })
//            let end_demand = UIAction(title: "수요조사 종료", image: nil, handler: { _ in print("수요조사 종료") })
//            let on_sale = UIAction(title: "판매 중", image: nil, handler: { _ in print("판매 중") })
//            let end_sale = UIAction(title: "판매 종료", image: nil, handler: { _ in print("판매 종료") })
//            
//            $0.menu = UIMenu(title: "정렬",
//                             image: UIImage(systemName: "heart.fill"),
//                             identifier: nil,
//                             options: .displayInline,
//                             children: [on_demand, end_demand, on_sale, end_sale])
//            $0.showsMenuAsPrimaryAction = true // 꾹 안눌러도 메뉴 표시
//        }
        
        let itemsStackView = UIStackView.init(arrangedSubviews: [searchButton, /*menuButton*/])
        itemsStackView.distribution = .equalSpacing
        itemsStackView.axis = .horizontal
        itemsStackView.alignment = .center
        itemsStackView.spacing = 12
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: uploadButton) // 왼쪽
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: itemsStackView) // 오른쪽
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = productHomeView.tableView
        tb.dataSource = self
        tb.delegate = self
        tb.prefetchDataSource = self // 페이징
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 120
        tb.register(ProductHomeCell.self, forCellReuseIdentifier: "ProductHomeCell")
    }
    
    // 새로고침 설정
    private func setupRefresh() {
        let rc = productHomeView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        productHomeView.tableView.refreshControl = rc
    }
    
}

// MARK: - @objc
extension ProductHomeViewController {
    // 업로드 버튼
    @objc func uploadButtonTapped() {
        if !AppDelegate.isLogin || AppDelegate.role == "user" {
            showAlertWithDismissDelay(message: "총대신청을 진행해주세요.")
        } else if AppDelegate.isLogin || AppDelegate.role == "manager" {
            let VC = UploadProductViewController()
            VC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    // 검색 버튼
    @objc func searchButtonTapped() {
        let VC = ProductSearchViewController()
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.count == 0 {
            tableView.setEmptyMessage("등록된 상품이 없습니다.")
        } else {
            tableView.restore()
        }
        
        return arrayProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHomeCell", for: indexPath) as! ProductHomeCell
        
        let data = arrayProduct[indexPath.row]
        
        if let imageUrl = URL(string: data.imageUrl) {
            cell.thumnailImage.kf.setImage(with: imageUrl)
        }
        
        cell.productNameLabel.text = data.productName
        cell.productPriceLabel.text = "\(data.price)원"
        
        var productStatus: String = ""
        var productStatusColor: UIColor = .systemGray2
        
        switch data.saleStatus {
        case "ON_DEMAND":
            productStatus = "수요조사 중"
            productStatusColor = .systemPink
        case "END_DEMAND":
            productStatus = "수요조사 종료"
        case "ON_SALE":
            productStatus = "판매 중"
            productStatusColor = .systemBlue
        case "END_SALE":
            productStatus = "판매 종료"
        case "COMPLETE":
            productStatus = "공구 종료"
        default:
            break
        }
        
        cell.productStateLabel.text = productStatus
        cell.productStateLabel.textColor = productStatusColor
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ProductDetailViewController()
        VC.productId = arrayProduct[indexPath.row].id // 아이디값 넘겨주기
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ProductHomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths { // 페이징
            if arrayProduct.count - 1 == indexPath.row && pageNum < totalPageNum && !isLastPage {

                pageNum += 1
                
                ProductNetworkManager.shared.getProductAll(page: pageNum) { model in
                    if let model = model {
                        self.arrayProduct += model.content
                        self.isLastPage = model.last
                        DispatchQueue.main.async {
                            self.productHomeView.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
