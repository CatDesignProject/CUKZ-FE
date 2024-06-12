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
    
    var isAllPurchase: Bool = false
    var isPurchaseManager:Bool = false
    var purchaseProduct: AllPurchaseUserResponse.Content? // 내가 구매한 상품 전체 목록에서 넘어왔을 떄
    
    private let purchaseParticipateInfoView = PurchaseParticipateInfoView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseParticipateInfoView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isAllPurchase || self.isPurchaseManager {
            setupUI()
        }
        
        setupNaviBar()
        setupButton()
        
    }
    
    private func setupUI() {
        guard let purchaseProduct = self.purchaseProduct else { return }
        DispatchQueue.main.async {
            if self.isAllPurchase {
                self.purchaseParticipateInfoView.completeButton.setTitle("총 \(purchaseProduct.totalPrice)원\n총대계좌: 농협123456789", for: .normal)
            } else if self.isPurchaseManager {
                self.purchaseParticipateInfoView.completeButton.setTitle("총 \(purchaseProduct.totalPrice)원", for: .normal)
            }
            
            self.purchaseParticipateInfoView.completeButton.titleLabel?.numberOfLines = 0
            self.purchaseParticipateInfoView.completeButton.titleLabel?.textAlignment = .center
            self.purchaseParticipateInfoView.buyerNameTextField.text = purchaseProduct.buyerName
            self.purchaseParticipateInfoView.buyerPhoneTextField.text = purchaseProduct.buyerPhone
            self.purchaseParticipateInfoView.recipientNameTextField.text = purchaseProduct.recipientName
            self.purchaseParticipateInfoView.recipientPhoneTextField.text = purchaseProduct.recipientPhone
            self.purchaseParticipateInfoView.addressTextField.text = purchaseProduct.address
            self.purchaseParticipateInfoView.payerNameTextfield.text = purchaseProduct.payerName
            self.purchaseParticipateInfoView.refundNameTextfield.text = purchaseProduct.refundName
            self.purchaseParticipateInfoView.refundAccountTextfield.text = purchaseProduct.refundAccount
            
            let textFields: [UITextField] = [
                self.purchaseParticipateInfoView.buyerNameTextField,
                self.purchaseParticipateInfoView.buyerPhoneTextField,
                self.purchaseParticipateInfoView.recipientNameTextField,
                self.purchaseParticipateInfoView.recipientPhoneTextField,
                self.purchaseParticipateInfoView.addressTextField,
                self.purchaseParticipateInfoView.payerNameTextfield,
                self.purchaseParticipateInfoView.refundNameTextfield,
                self.purchaseParticipateInfoView.refundAccountTextfield
            ]
            
            textFields.forEach { $0.isEnabled = false }
        }
    }
    
    private func setupNaviBar() {
        title = "개인정보 입력"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if self.isAllPurchase {
            let goToProductButton = UIBarButtonItem(title: "상품 보기",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(goToProductButtonTapped))
            
            navigationItem.rightBarButtonItem = goToProductButton
        } else if self.isPurchaseManager {
            guard let purchaseProduct = self.purchaseProduct else { return }
            let title = purchaseProduct.payStatus ? "입금 확인 취소" : "입금 확인"
            let payCheckButton = UIBarButtonItem(title: title,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(payCheckButtonTapped))
            navigationItem.rightBarButtonItem = payCheckButton
        }
    }
    
    private func setupButton() {
        if self.isPurchaseManager {
            DispatchQueue.main.async {
                
            }
        } else {
            purchaseParticipateInfoView.completeButton.addTarget(self,
                                                             action: #selector(completeButtonTapped),
                                                             for: .touchUpInside)
        }
    }
}

// MARK: - Actions
extension PurchaseParticipateInfoViewController {
    // 상품보기 버튼
    @objc private func goToProductButtonTapped() {
        let VC = ProductDetailViewController()
        if let productId = self.productId {
            VC.productId = productId
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 입금확인
    @objc private func payCheckButtonTapped() {
        guard let purchaseProduct = self.purchaseProduct else { return }
        
        let actionTitle = purchaseProduct.payStatus ? "입금 확인 취소" : "입금 확인"
        let alertMessage = purchaseProduct.payStatus ? "입금 확인 취소 완료" : "입금 확인 완료"
        
        let sheet = UIAlertController(title: nil, message: "\(actionTitle) 하시겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            PurchaseNetworkManager.shared.postPurchasePayCheck(purchaseFormId: purchaseProduct.id,
                                                               payStatus: !purchaseProduct.payStatus) { error in
                if let error = error {
                    print("\(actionTitle) 실패: \(error.localizedDescription)")
                } else {
                    print("\(actionTitle) 성공")
                    DispatchQueue.main.async {
                        if let navigationController = self.navigationController {
                            for viewController in navigationController.viewControllers {
                                if let purchaseManagerVC = viewController as? PurchaseManagerViewController {
                                    purchaseManagerVC.fetchData()
                                    navigationController.popToViewController(purchaseManagerVC, animated: true)
                                    break
                                }
                            }
                        }
                        self.showAlertWithDismissDelay(message: alertMessage)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }
    
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
