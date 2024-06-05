//
//  PurchaseParticipateViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/31/24.
//

import UIKit

final class PurchaseParticipateViewController: UIViewController {
    // MARK: - Properties
    private let purchaseParticipateView = PurchaseParticipateView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseParticipateView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        let tb = purchaseParticipateView.tableView
        tb.dataSource = self
        tb.delegate = self
        
        tb.tableHeaderView = UIView()
        tb.rowHeight = 55
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
        
        let topView = PurchaseParticipateTopView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        // 동적 높이 설정을 돕기 위해 containerView에 topView 추가
        let containerView = UIView()
        containerView.addSubview(topView)
        tb.tableHeaderView = containerView
        
        // containerView 내에서 topView에 대한 제약 조건 설정
        topView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
            make.width.equalTo(tb.bounds.width)
        }
        
        // 레이아웃 패스를 강제하여 올바른 높이 계산
        containerView.layoutIfNeeded()
        
        // 계산된 높이를 기반으로 containerView의 프레임 업데이트
        var frame = containerView.frame
        frame.size.height = topView.intrinsicContentSize.height
        containerView.frame = frame
        
        // containerView를 tableHeaderView로 할당
        tb.tableHeaderView = containerView
    }
}

// MARK: - UITableViewDataSource
extension PurchaseParticipateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PurchaseParticipateViewController: UITableViewDelegate {
    
}
