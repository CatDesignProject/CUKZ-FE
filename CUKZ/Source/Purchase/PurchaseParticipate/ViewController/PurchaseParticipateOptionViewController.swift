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
    
    private let purchaseParticipateOptionView = PurchaseParticipateOptionView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseParticipateOptionView
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
        let tb = purchaseParticipateOptionView.tableView
        tb.dataSource = self
        tb.rowHeight = 55
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
    }
    
    private func setupButton() {
        purchaseParticipateOptionView.completeButton.addTarget(self,
                                                         action: #selector(completeButtonTapped),
                                                         for: .touchUpInside)
    }
}

// MARK: - Actions
extension PurchaseParticipateOptionViewController {
    // 개입정보 입력 버튼
    @objc private func completeButtonTapped() {
        guard let productId = self.productId else { return }
        
        // 테이블 뷰에서 각 셀의 데이터를 수집하여 `requestOptionList` 배열에 저장
        var requestOptionList: [PurchaseParticipateRequest.OptionList] = []
        var hasValidQuantity = false

        for index in 0..<purchaseParticipateOptionView.tableView.numberOfRows(inSection: 0) {
            guard let cell = purchaseParticipateOptionView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DemandParticipateCell,
                  let optionId = optionList?[index].id,
                  let quantityText = cell.quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !quantityText.isEmpty,
                  let quantity = Int(quantityText), quantity > 0 else {
                continue
            }

            let option = PurchaseParticipateRequest.OptionList(optionId: optionId, quantity: quantity)
            requestOptionList.append(option)
            hasValidQuantity = true
        }

        if !hasValidQuantity {
            showAlertWithDismissDelay(message: "수량을 정확히 입력해주세요.")
            return
        }
        
        let VC = PurchaseParticipateInfoViewController()
        VC.productId = productId
        VC.requestOptionList = requestOptionList
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
