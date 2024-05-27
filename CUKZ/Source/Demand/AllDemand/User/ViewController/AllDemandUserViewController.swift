//
//  AllDemandUserViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/28/24.
//

import UIKit

final class AllDemandUserViewController: UIViewController {
    // MARK: - Properties
    private var arrayProduct: [AllDemandUserRespose.Content] = []
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
    }
    
    private func fetchData() {
        DemandNetworkManager.shared.getAllDemandUser(page: 1) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                
                self.totalPageNum = data.totalPage
                self.isLastPage = data.last
                self.arrayProduct = data.content
                DispatchQueue.main.async {
                    self.allDemandUserView.tableView.reloadData()
                }
            case .failure(let error):
                print("내가 참여한 수요조사 전체 목록 조회 실패: \(error)")
            }
        }
    }
    
    private func setupNaviBar() {
        title = "내가 참여한 수요조사"
    }
    
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = allDemandUserView.tableView
        tb.dataSource = self
        tb.delegate = self
//        tb.prefetchDataSource = self // 페이징
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 120
        tb.register(ProductHomeCell.self, forCellReuseIdentifier: "ProductHomeCell")
    }
}

// MARK: - UITableViewDataSource
extension AllDemandUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.count == 0 {
            tableView.setEmptyMessage("내가 참여한 수요조사 상품이 없습니다.")
        } else {
            tableView.restore()
        }
        
        return arrayProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHomeCell", for: indexPath) as! ProductHomeCell
        
        return cell
    }
}

extension AllDemandUserViewController: UITableViewDelegate {
    
}
