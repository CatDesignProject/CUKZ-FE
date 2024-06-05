//
//  AllDemandManagerViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class AllDemandManagerViewController: UIViewController {
    // MARK: - Properties
    private var arrayProduct: [ProductHomeModel.Content] = []
    private var totalPageNum: Int = 0
    private var pageNum: Int = 0
    private var isLastPage: Bool = false
    
    private let allDemandManagerView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = allDemandManagerView
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
        
    }
    
    private func setupNaviBar() {
        title = "수요조사 참여 인원"
    }
    
    private func setupTableView() {
        let tb = allDemandManagerView.tableView
        tb.dataSource = self
        tb.prefetchDataSource = self // 페이징
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 55
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
    }
    
    private func setupRefresh() {
        let rc = allDemandManagerView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        allDemandManagerView.tableView.refreshControl = rc
    }
}

// MARK: - Actions
extension AllDemandManagerViewController {
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension AllDemandManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension AllDemandManagerViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}
