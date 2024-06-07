//
//  DemandCountViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class DemandCountViewController: UIViewController {
    // MARK: - Properties
    private var arrayProduct: [AllDemandUserRespose.OptionList] = []
    var productId: Int?
    
    private let allDemandManagerView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = allDemandManagerView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupNaviBar()
        setupTableView()
        setupRefresh()
    }
    
    private func fetchData() {
        guard let productId = self.productId else { return }
        DemandNetworkManager.shared.getDemandManager(productId: productId) { [weak self] result in
            switch result {
            case .success(let data):
                print("수요조사 폼 통계 조회 성공")
                self?.arrayProduct = data // 데이터 배열 할당
                DispatchQueue.main.async {
                    self?.allDemandManagerView.tableView.reloadData()
                }
            case .failure(let error):
                print("수요조사 폼 통계 조회 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNaviBar() {
        title = "수요조사 참여 인원"
    }
    
    private func setupTableView() {
        let tb = allDemandManagerView.tableView
        tb.dataSource = self
        
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
extension DemandCountViewController {
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension DemandCountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProduct.isEmpty {
            tableView.setEmptyMessage("참여한 인원이 없습니다.")
        } else {
            tableView.restore()
        }
        return arrayProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        cell.quantityTextField.isEnabled = false
        
        let product = arrayProduct[indexPath.row]
        cell.additionalPrice.text = "+ \(product.additionalPrice)원"
        cell.optionNameLabel.text = product.optionName
        cell.quantityTextField.text = "\(product.quantity)"
        return cell
    }
}
