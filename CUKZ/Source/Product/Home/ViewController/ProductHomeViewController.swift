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
    var arrayProduct: [ProductHomeModel.Content] = []
    var totalPageNum: Int = 0
    var pageNum: Int = 0
    var isLastPage: Bool = false
    
    private let productHomeView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productHomeView
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData() // ** 수정필요 **
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTableView()
        setupRefresh()
    }
    
    // 네트워킹
    private func fetchData() {
        ProductNetworkManager.shared.getProductAll(page: 0) { model in
            if let model = model {
                self.totalPageNum = model.body.totalPage
                self.isLastPage = model.body.last
                self.arrayProduct = model.body.content
                DispatchQueue.main.async {
                    self.productHomeView.tableView.reloadData()
                }
            }
        }
    }
    
    // 네비게이션바 설정
    private func setupNaviBar() {
        title = "상품"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .gadaeBlue
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "상품 검색"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadButtonTapped))
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
        let VC = UploadProductViewController()
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("상품 목록 전체 조회 - 새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        var saleStatus = ""
        
//        switch data.status {
//        case "ON_DEMAND":
//            saleStatus = "수요조사 중"
//        case "END_DEMAND":
//            saleStatus = "수요조사 종료"
//        case "ON_SALE":
//            saleStatus = "판매 중"
//        case "END_SALE":
//            saleStatus = "판매 종료"
//        default:
//            print("")
//        }
        
        cell.productStateLabel.text = saleStatus
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ProductDetailViewController()
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
                        self.arrayProduct += model.body.content
                        self.isLastPage = model.body.last
                        DispatchQueue.main.async {
                            self.productHomeView.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
