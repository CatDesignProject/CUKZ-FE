//
//  DemandParticipateViewController.swift
//  CUKZ
//
//  Created by 이승민 on 5/16/24.
//

import UIKit

final class DemandParticipateViewController: UIViewController {
    // MARK: - Properties
    var optionList: [ProductDetailModel.Option]? // 상세보기에서 넘어온 옵션 배열
    var demandParticipateList: [DemandParticipateRequest] = [] // post 보낼 때 담는 배열
    
    private let demandParticipateView = DemandParticipateView()
    
    // MARK: - View 설정
    override func loadView() {
        view = demandParticipateView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        let tb = demandParticipateView.tableView
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
        tb.dataSource = self
        tb.rowHeight = 55
    }
}

extension DemandParticipateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.optionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        
        guard let options = self.optionList else { return UITableViewCell() }
        
        cell.optionNameLabel.text = options[indexPath.row].name
        cell.additionalPrice.text = "+ \(options[indexPath.row].additionalPrice)원"
        
        return cell
    }
}
