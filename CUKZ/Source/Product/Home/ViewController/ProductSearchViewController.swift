//
//  ProductSearchViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/14/24.
//

import UIKit

final class ProductSearchViewController: UIViewController {
    // MARK: - Properties
    private var arrayProductSearch: [ProductHomeModel.Content] = []
    private var totalPageNum: Int = 0
    private var pageNum: Int = 0
    private var isLastPage: Bool = false
    private var keyword: String?
    private var isFirstTimeViewed = true // 처음 보는 뷰인지 여부
    
    private let productHomeView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productHomeView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTableView()
    }
    
    // 네비게이션바 설정
    private func setupNaviBar() {
        let searchBar = UISearchBar()
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.placeholder = "상품 이름"
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .gadaeBlue // 원하는 색상으로 설정
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true // 백버튼 숨기기
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelButton
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
}

// MARK: - @objc
extension ProductSearchViewController {
    // 취소 버튼
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProductSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFirstTimeViewed { // 처음 보는 화면일 때
            tableView.setEmptyMessage("상품을 검색해보세요")
        } else if arrayProductSearch.count == 0 { // 검색한 상품이 없을 때
            tableView.setEmptyMessage("상품을 찾을 수 없습니다")
        } else {
            tableView.restore()
        }
        
        return arrayProductSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHomeCell", for: indexPath) as! ProductHomeCell
        
        let data = arrayProductSearch[indexPath.row]
        
        if let imageUrl = URL(string: data.imageUrl) {
            cell.thumnailImage.kf.setImage(with: imageUrl)
        }
        
        cell.productNameLabel.text = data.productName
        cell.productPriceLabel.text = "\(data.price)원"
        
        var productStatus: String = ""
        var productStatusColor: UIColor = .systemGray
        
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
        default:
            print("")
        }
        
        cell.productStateLabel.text = productStatus
        cell.productStateLabel.textColor = productStatusColor
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ProductDetailViewController()
        VC.productId = arrayProductSearch[indexPath.row].id // 아이디값 넘겨주기
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ProductSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths { // 페이징

            if arrayProductSearch.count - 1 == indexPath.row && pageNum < totalPageNum && !isLastPage {
                
                pageNum += 1
                guard let keyword = self.keyword else { return }
                ProductNetworkManager.shared.getProductSearch(keyword: keyword,
                                                              page: pageNum) { model, error in
                    if let model = model {
                        self.arrayProductSearch += model.content
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

// MARK: - UISearchBarDelegate
extension ProductSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // 키보드 검색 버튼 클릭
        searchBar.resignFirstResponder() // 키보드 내리기
        
        self.isFirstTimeViewed = false
        self.pageNum = 0
        guard let keyword = searchBar.text else { return }
        self.keyword = keyword
        
        ProductNetworkManager.shared.getProductSearch(keyword: keyword,
                                                      page: 0) { model, error in
            if error != nil {
                self.arrayProductSearch.removeAll()
            } else {
                if let model = model {
                    self.totalPageNum = model.totalPage
                    self.isLastPage = model.last
                    self.arrayProductSearch = model.content
                }
            }
            DispatchQueue.main.async {
                self.productHomeView.tableView.reloadData()
            }
        }
    }
}
