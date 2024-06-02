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
    
    var isAllDemand: Bool = false // 참여한 수요조사 전체 목록 조회에서 push 여부
    var demandId: Int? // 단건 조회 아이디
    private var demandData: AllDemandUserRespose.Content?
    
    private let demandParticipateView = DemandParticipateView()
    
    // MARK: - View 설정
    override func loadView() {
        view = demandParticipateView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAllDemand { // 참여한 수요조사 전체 목록 조회에서 push 됐을 때
            fetchData()
        }
        
        setupNaviBar()
        setupTableView()
    }
    
    private func fetchData() {
        if let demandId = self.demandId {
            DemandNetworkManager.shared.getDemandUser(demandId: demandId) { result in
                switch result {
                case .success(let data):
                    print("내가 참여한 수요조사 단건 조회 성공")
                    guard let data = data else { return }
                    
                    self.demandData = data
                    
                    DispatchQueue.main.async {
                        self.demandParticipateView.emailTextField.text = data.email
                        self.demandParticipateView.emailTextField.isEnabled = false
                        self.demandParticipateView.completeButton.isHidden = true
                        self.demandParticipateView.tableView.reloadData()
                    }
                case .failure(let error):
                    print("내가 참여한 수요조사 단건 조회 실패: \(error)")
                }
            }
        }
    }
    
    private func setupNaviBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isAllDemand {
            let goToProductButton = UIBarButtonItem(title: "상품 보기",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(goToProductButtonTapped))
            
            navigationItem.rightBarButtonItem = goToProductButton
        }
    }
    
    @objc private func goToProductButtonTapped() {
        let VC = ProductDetailViewController()
        if let productId = self.demandData?.productId {
            VC.productId = productId
        }
        navigationController?.pushViewController(VC, animated: true)
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
        if isAllDemand {
            self.demandData?.optionList.count ?? 0
        } else {
            self.optionList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemandParticipateCell", for: indexPath) as! DemandParticipateCell
        
        if isAllDemand {
            guard let options = self.demandData?.optionList[indexPath.row] else { return UITableViewCell() }
            cell.optionNameLabel.text = "\(options.optionName)"
            cell.quantityTextField.text = "\(options.quantity)"
            cell.quantityTextField.isEnabled = false
        } else {
            guard let options = self.optionList?[indexPath.row] else { return UITableViewCell() }
            cell.optionNameLabel.text = options.name
            cell.additionalPrice.text = "+ \(options.additionalPrice)원"
        }
        
        return cell
    }
}
