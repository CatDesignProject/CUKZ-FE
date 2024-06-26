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
    
    var productId: Int?
    var isAllDemand: Bool = false // 참여한 수요조사 전체 목록 조회에서 push 여부
    var demandId: Int? // 단건 조회 아이디
    private var demandData: AllDemandUserResponse.Content?
    
    let demandParticipateView = DemandParticipateView()
    
    // MARK: - View 설정
    override func loadView() {
        view = demandParticipateView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAllDemand { // 참여한 수요조사 전체 목록 조회에서 push 됐을 때
            DispatchQueue.main.async {
                self.demandParticipateView.emailTextField.isEnabled = false
                self.demandParticipateView.completeButton.isHidden = true
            }
            fetchData()
        }
        
        setupNaviBar()
        setupTableView()
        setupButton()
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
    
    private func setupTableView() {
        let tb = demandParticipateView.tableView
        tb.register(DemandParticipateCell.self, forCellReuseIdentifier: "DemandParticipateCell")
        tb.dataSource = self
        tb.rowHeight = 55
    }
    
    private func setupButton() {
        DispatchQueue.main.async {
            self.demandParticipateView.completeButton.backgroundColor = .systemPink
        }
        
        demandParticipateView.completeButton.addTarget(self,
                                                       action: #selector(completeButtonTapped),
                                                       for: .touchUpInside)
    }
    
    // 이메일 형식 검증 함수
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

// MARK: - Actions
extension DemandParticipateViewController {
    // 수요조사 참여 단건 조회할 때 상품보기 버튼
    @objc private func goToProductButtonTapped() {
        let VC = ProductDetailViewController()
        if let productId = self.demandData?.productId {
            VC.productId = productId
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
    // 수요조사 참여하기 버튼
    @objc private func completeButtonTapped() {
        guard let productId = self.productId,
              let email = self.demandParticipateView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              isValidEmail(email) else {
            showAlertWithDismissDelay(message: "유효한 이메일을 입력해주세요.")
            return
        }

        // 테이블 뷰에서 각 셀의 데이터를 수집하여 `requestOptionList` 배열에 저장
        var requestOptionList: [DemandParticipateRequest.OptionList] = []
        var hasValidQuantity = false

        for index in 0..<demandParticipateView.tableView.numberOfRows(inSection: 0) {
            guard let cell = demandParticipateView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DemandParticipateCell,
                  let optionId = optionList?[index].id,
                  let quantityText = cell.quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !quantityText.isEmpty,
                  let quantity = Int(quantityText), quantity > 0 else {
                continue
            }

            let option = DemandParticipateRequest.OptionList(optionId: optionId, quantity: quantity)
            requestOptionList.append(option)
            hasValidQuantity = true
        }

        if !hasValidQuantity {
            showAlertWithDismissDelay(message: "수량을 정확히 입력해주세요.")
            return
        }

        let parameters = DemandParticipateRequest(email: email, optionList: requestOptionList)

        DemandNetworkManager.shared.postDemand(productId: productId, parameters: parameters) { error in
            if let error = error {
                print("수요조사 참여 실패: \(error.localizedDescription)")
                self.showAlertWithDismissDelay(message: "해당 이메일로 이미 참여했습니다.")
            } else {
                print("수요조사 참여 성공")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.showAlertWithDismissDelay(message: "수요조사 참여 완료")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
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
            cell.additionalPrice.text = "+ \(options.additionalPrice)원"
        } else {
            guard let options = self.optionList?[indexPath.row] else { return UITableViewCell() }
            cell.optionNameLabel.text = options.name
            cell.additionalPrice.text = "+ \(options.additionalPrice)원"
        }
        
        return cell
    }
}
