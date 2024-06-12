//
//  PurchaseManagerViewController.swift
//  CUKZ
//
//  Created by 이승민 on 6/13/24.
//

import UIKit

final class PurchaseManagerViewController: UIViewController {
    // MARK: - Properties
    var productId: Int?
    
    private var arrayContent: [AllPurchaseUserResponse.Content] = []
    private var totalPageNum: Int = 0
    private var pageNum: Int = 0
    private var isLastPage: Bool = false
    
    private let purchaseManagerView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseManagerView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupNaviBar()
        setupTableView()
        setupRefresh()
    }
    
    func fetchData() {
        self.pageNum = 1
        guard let productId = self.productId else { return }
        PurchaseNetworkManager.shared.getAllPurchaseManager(productId: productId, 
                                                            page: 1) { result in
            switch result {
            case .success(let data):
                print("(총대) 구매하기한 인원 전체 목록 조회 성공")
                self.title = "구매하기한 인원 \(data.totalElements)명"
                self.totalPageNum = data.totalPage
                self.isLastPage = data.last
                self.arrayContent = data.content
                DispatchQueue.main.async {
                    self.purchaseManagerView.tableView.reloadData()
                }
            case .failure(let error):
                print("(총대) 구매하기한 인원 전체 목록 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = purchaseManagerView.tableView
        tb.dataSource = self
        tb.delegate = self
        tb.prefetchDataSource = self // 페이징
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 120
        tb.register(PurchaseManagerCell.self, forCellReuseIdentifier: "PurchaseManagerCell")
    }
    
    private func setupRefresh() {
        let rc = purchaseManagerView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        purchaseManagerView.tableView.refreshControl = rc
    }
}

// MARK: - Actions
extension PurchaseManagerViewController{
    @objc func refreshTable(refresh: UIRefreshControl) {
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension PurchaseManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayContent.count == 0 {
            tableView.setEmptyMessage("구매하기한 인원이 없습니다.")
        } else {
            tableView.restore()
        }
        
        return arrayContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseManagerCell", for: indexPath) as! PurchaseManagerCell
        
        let data = arrayContent[indexPath.row]
        
        cell.buyerNameLabel.text = data.buyerName
        cell.buyerPhoneLabel.text = data.buyerPhone
        cell.totalPriceLabel.text = "총 \(data.totalPrice)원"
        cell.checkIcon.isHidden = !data.payStatus
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PurchaseManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = PurchaseParticipateOptionViewController()
        VC.productId = self.arrayContent[indexPath.row].productId
        VC.isPurchaseManager = true
        VC.purchaseProduct = self.arrayContent[indexPath.row]
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension PurchaseManagerViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths { // 페이징
            guard let productId = self.productId else { return }
            
            if arrayContent.count - 1 == indexPath.row && pageNum <= totalPageNum && !isLastPage {

                pageNum += 1
                
                PurchaseNetworkManager.shared.getAllPurchaseManager(productId: productId,
                                                                    page: pageNum) { result in
                    switch result {
                    case .success(let data):
                        print("(총대) 구매하기한 인원 전체 목록 조회 페이징 성공")
                        self.isLastPage = data.last
                        self.arrayContent += data.content
                        DispatchQueue.main.async {
                            self.purchaseManagerView.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("(총대) 구매하기한 인원 전체 목록 조회 페이징 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
