//
//  AllPurchaseUserViewController.swift
//  CUKZ
//
//  Created by 이승민 on 6/13/24.
//

import UIKit

final class AllPurchaseUserViewController: UIViewController {
    // MARK: - Properties
    private var arrayContent: [AllPurchaseUserResponse.Content] = []
    private var totalPageNum: Int = 0
    private var pageNum: Int = 0
    private var isLastPage: Bool = false
    
    private let allDemandUserView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = allDemandUserView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupNaviBar()
        setupTableView()
        setupRefresh()
    }
    
    private func fetchData() {
        self.pageNum = 1
        PurchaseNetworkManager.shared.getAllPurchaseUser(page: 1) { result in
            switch result {
            case .success(let data):
                print("내가 구매한 상품 전체 목록 조회 성공")
                self.totalPageNum = data.totalPage
                self.isLastPage = data.last
                self.arrayContent = data.content
                DispatchQueue.main.async {
                    self.allDemandUserView.tableView.reloadData()
                }
            case .failure(let error):
                print("내가 구매한 상품 전체 목록 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNaviBar() {
        title = "내가 구매하기한 상품"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = allDemandUserView.tableView
        tb.dataSource = self
        tb.delegate = self
        tb.prefetchDataSource = self // 페이징
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 120
        tb.register(ProductHomeCell.self, forCellReuseIdentifier: "ProductHomeCell")
    }
    
    private func setupRefresh() {
        let rc = allDemandUserView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        allDemandUserView.tableView.refreshControl = rc
    }
}

// MARK: - Actions
extension AllPurchaseUserViewController{
    @objc func refreshTable(refresh: UIRefreshControl) {
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension AllPurchaseUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayContent.count == 0 {
            tableView.setEmptyMessage("내가 구매한 상품이 없습니다.")
        } else {
            tableView.restore()
        }
        
        return arrayContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHomeCell", for: indexPath) as! ProductHomeCell
        
        let data = arrayContent[indexPath.row]
        
        if let imageUrlString = data.imageUrlList.first,
           let imageUrl = URL(string: imageUrlString) {
            cell.thumnailImage.kf.setImage(with: imageUrl)
        }
        cell.productNameLabel.text = data.productName
        cell.productPriceLabel.text = "총 \(data.totalPrice)원"
        cell.productStateLabel.textColor = .gadaeBlue
        if data.payStatus {
            if data.status  == "COMPLETE" {
                cell.productStateLabel.text = "입금확인 완료 ✅ (리뷰작성가능)"
            } else {
                cell.productStateLabel.text = "입금확인 완료 ✅"
            }
        } else {
            cell.productStateLabel.text = "입금확인 ❌"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AllPurchaseUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = PurchaseParticipateOptionViewController()
        VC.productId = self.arrayContent[indexPath.row].productId
        VC.isAllPurchase = true
        VC.purchaseProduct = self.arrayContent[indexPath.row]
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension AllPurchaseUserViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths { // 페이징
            if arrayContent.count - 1 == indexPath.row && pageNum < totalPageNum && !isLastPage {

                pageNum += 1
                
                PurchaseNetworkManager.shared.getAllPurchaseUser(page: pageNum) { result in
                    switch result {
                    case .success(let data):
                        print("내가 구매한 상품 전체 목록 조회 페이징 성공")
                        self.isLastPage = data.last
                        self.arrayContent += data.content
                        DispatchQueue.main.async {
                            self.allDemandUserView.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("내가 구매한 상품 전체 목록 조회 페이징 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
