//
//  PurchaseParticipateInfoViewController.swift
//  CUKZ
//
//  Created by 이승민 on 6/12/24.
//

import UIKit

final class PurchaseParticipateInfoViewController: UIViewController {
    // MARK: - Properties
    var optionList: [ProductDetailModel.Option]? // 상세보기에서 넘어온 옵션 배열
    
    private let purchaseParticipateInfoView = PurchaseParticipateInfoView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseParticipateInfoView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        setupButton()
    }
    
    private func setupNaviBar() {
        title = "개인정보 입력"
    }
    
    private func setupButton() {
        purchaseParticipateInfoView.completeButton.addTarget(self,
                                                         action: #selector(completeButtonTapped),
                                                         for: .touchUpInside)
    }
}

// MARK: - Actions
extension PurchaseParticipateInfoViewController {
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
