//
//  PurchaseParticipateInfoViewController.swift
//  CUKZ
//
//  Created by 이승민 on 6/12/24.
//

import UIKit

final class PurchaseParticipateInfoViewController: UIViewController {
    // MARK: - Properties
    var requestOptionList: [PurchaseParticipateRequest.OptionList]? // 옵션선택에서 넘어온 옵션 배열
    var productId: Int?
    
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
        guard let productId = self.productId,
              let requestOptionList = self.requestOptionList else { return }
        
        guard let buyerName = self.purchaseParticipateInfoView.buyerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !buyerName.isEmpty,
              let buyerPhone = self.purchaseParticipateInfoView.buyerPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !buyerPhone.isEmpty,
              let recipientName = self.purchaseParticipateInfoView.recipientNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !recipientName.isEmpty,
              let recipientPhone = self.purchaseParticipateInfoView.recipientPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !recipientPhone.isEmpty,
              let address = self.purchaseParticipateInfoView.addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !address.isEmpty,
              let payerName = self.purchaseParticipateInfoView.payerNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !payerName.isEmpty,
              let refundName = self.purchaseParticipateInfoView.refundNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !refundName.isEmpty,
              let refundAccount = self.purchaseParticipateInfoView.refundAccountTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !refundAccount.isEmpty else {
            showAlertWithDismissDelay(message: "모두 입력해주세요")
            return
        }
        
        let parameters = PurchaseParticipateRequest(buyerName: buyerName, buyerPhone: buyerPhone, recipientName: recipientName, recipientPhone: recipientPhone, address: address, payerName: payerName, refundName: refundName, refundAccount: refundAccount, optionList: requestOptionList)
        
        PurchaseNetworkManager.shared.postPurchase(productId: productId, parameters: parameters) { error in
            if let error = error {
                print("구매하기 실패: \(error.localizedDescription)")
            } else {
                print("구매하기 성공")
                DispatchQueue.main.async {
                    if let navigationController = self.navigationController {
                        for viewController in navigationController.viewControllers {
                            if viewController is ProductDetailViewController {
                                navigationController.popToViewController(viewController, animated: true)
                                break
                            }
                        }
                    }
                    self.showAlertWithDismissDelay(message: "구매하기 완료")
                }
            }
        }
    }
}
