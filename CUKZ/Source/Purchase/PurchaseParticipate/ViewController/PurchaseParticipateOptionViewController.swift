//
//  PurchaseParticipateOptionViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class PurchaseParticipateOptionViewController: UIViewController {
    // MARK: - Properties
    var optionList: [ProductDetailModel.Option]? // 상세보기에서 넘어온 옵션 배열
    var productId: Int?
    
    private let purchaseParticipateView = PurchaseParticipateOptionView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseParticipateView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        setupTableView()
        setupButton()
    }
    
    private func setupNaviBar() {
        title = "옵션 선택"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        let tb = purchaseParticipateView.tableView
        tb.dataSource = self
        tb.rowHeight = 55
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
    }
    
    private func setupButton() {
        purchaseParticipateView.completeButton.addTarget(self,
                                                         action: #selector(completeButtonTapped),
                                                         for: .touchUpInside)
    }
}

// MARK: - Actions
extension PurchaseParticipateOptionViewController {
    
    @objc private func completeButtonTapped() {
        let VC = PurchaseParticipateInfoViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PurchaseParticipateOptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        
        guard let options = self.optionList?[indexPath.row] else { return UITableViewCell() }
        cell.optionNameLabel.text = options.name
        cell.additionalPrice.text = "+ \(options.additionalPrice)원"
        
        return cell
    }
}
