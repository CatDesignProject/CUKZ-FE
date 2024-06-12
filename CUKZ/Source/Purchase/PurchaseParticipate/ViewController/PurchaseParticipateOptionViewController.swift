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
    }
    
    private func setupTableView() {
        let tb = purchaseParticipateView.tableView
        tb.dataSource = self
        tb.rowHeight = 55
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
    }
    
    private func setupButton() {
        DispatchQueue.main.async {
            let bt = self.purchaseParticipateView.completeButton
            bt.backgroundColor = .systemBlue
            bt.setTitle("개인정보 입력하기", for: .normal)
        }
        
        purchaseParticipateView.completeButton.addTarget(self,
                                                         action: #selector(completeButtonTapped),
                                                         for: .touchUpInside)
    }
}

// MARK: - Actions
extension PurchaseParticipateOptionViewController {
    // 구매하기 버튼
    @objc private func completeButtonTapped() {
//        guard let topView = purchaseParticipateView.tableView.tableHeaderView as? PurchaseParticipateTopView else {
//            print(purchaseParticipateView.tableView.tableHeaderView as? PurchaseParticipateTopView)
//            return
//        }
//        
//        guard let productId = self.productId else { return }
//        
//        guard let buyerName = topView.buyerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !buyerName.isEmpty else {
//            showAlertWithDismissDelay(message: "구매자 이름을 입력해주세요.")
//            return
//        }
//        
//        guard let buyerPhone = topView.buyerPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !buyerPhone.isEmpty else {
//            showAlertWithDismissDelay(message: "구매자 전화번호를 입력해주세요.")
//            return
//        }
//        
//        guard let recipientName = topView.recipientNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !recipientName.isEmpty else {
//            showAlertWithDismissDelay(message: "수령인 이름을 입력해주세요.")
//            return
//        }
//        
//        guard let recipientPhone = topView.recipientPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !recipientPhone.isEmpty else {
//            showAlertWithDismissDelay(message: "수령인 전화번호를 입력해주세요.")
//            return
//        }
//        
//        guard let address = topView.addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !address.isEmpty else {
//            showAlertWithDismissDelay(message: "주소를 입력해주세요.")
//            return
//        }
//        
//        guard let payerName = topView.payerNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !payerName.isEmpty else {
//            showAlertWithDismissDelay(message: "입금자 이름을 입력해주세요.")
//            return
//        }
//        
//        guard let refundName = topView.refundNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !refundName.isEmpty else {
//            showAlertWithDismissDelay(message: "환불 계좌주 이름을 입력해주세요.")
//            return
//        }
//        
//        guard let refundAccount = topView.refundAccountTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !refundAccount.isEmpty else {
//            showAlertWithDismissDelay(message: "환불 계좌를 입력해주세요.")
//            return
//        }
//        
//        // 옵션 데이터 수집
//        var requestOptionList: [PurchaseParticipateRequest.OptionList] = []
//        var hasValidQuantity = false
//
//        for index in 0..<purchaseParticipateView.tableView.numberOfRows(inSection: 0) {
//            guard let cell = purchaseParticipateView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DemandParticipateCell,
//                  let optionId = optionList?[index].id,
//                  let quantityText = cell.quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//                  !quantityText.isEmpty,
//                  let quantity = Int(quantityText), quantity > 0 else {
//                continue
//            }
//
//            let option = PurchaseParticipateRequest.OptionList(optionId: optionId, quantity: quantity)
//            requestOptionList.append(option)
//            hasValidQuantity = true
//        }
//
//        if !hasValidQuantity {
//            showAlertWithDismissDelay(message: "수량을 정확히 입력해주세요.")
//            return
//        }
//        
//        let parameters = PurchaseParticipateRequest(
//            buyerName: buyerName,
//            buyerPhone: buyerPhone,
//            recipientName: recipientName,
//            recipientPhone: recipientPhone,
//            address: address,
//            payerName: payerName,
//            refundName: refundName,
//            refundAccount: refundAccount,
//            optionList: requestOptionList
//        )
//        
//        PurchaseNetworkManager.shared.postPurchase(productId: productId, parameters: parameters) { error in
//            if let error = error {
//                print("구매 하기 실패 - \(error.localizedDescription)")
//            } else {
//                print("구매 하기 성공")
//                self.showAlertWithDismissDelay(message: "구매 완료")
//                DispatchQueue.main.async {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
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

extension PurchaseParticipateOptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PurchaseParticipateTopView()
        headerView.frame.size = headerView.intrinsicContentSize
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 800
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
