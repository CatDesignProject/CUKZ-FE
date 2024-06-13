//
//  ReviewViewController.swift
//  CUKZ
//
//  Created by 이승민 on 4/5/24.
//

import UIKit

final class ReviewViewController: UIViewController {
    // MARK: - Properties
    var isLeave: Bool?
    var sellerId: Int?
    var productId: Int?
    var purchaseFormId: Int?
    var nickname: String?
    
    private var isSellerKindnessSelected = false
    private var isGoodNotificationSelected = false
    private var isArrivalSatisfactorySelected = false
    private var isDescriptionMatchSelected = false
    
    private var reviewData: ReviewModel?
    
    private let reviewView = ReviewView()
    
    // MARK: - View 설정
    override func loadView() {
        view = reviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        prepare()
        setupButton()
        updateCompleteButton()
    }
    
    private func fetchData() {
        guard let sellerId = self.sellerId else { return }
        ReviewNetworkManager.shared.getReview(sellerId: sellerId) { model in
            self.reviewData = model
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        guard let data = self.reviewData else { return }
        
        if let isLeave = self.isLeave, isLeave == true, let nickname = self.nickname {
            reviewView.nicknameLabel.text = "\(nickname) 님의\n이런 점이 좋았어요"
        }
        
        reviewView.nicknameLabel.text = "\(data.nickname) 님의\n이런 점이 좋았어요"
        reviewView.firstQuestionNumLabel.text = "\(data.sellerKindnessCnt)"
        reviewView.secondQuestionNumLabel.text = "\(data.goodNotificationCnt)"
        reviewView.thirdQuestionNumLabel.text = "\(data.descriptionMatchCnt)"
        reviewView.fourthQuestionNumLabel.text = "\(data.arrivalSatisfactoryCnt)"
    }
    
    private func prepare() {
        DispatchQueue.main.async {
            if self.isLeave == false {
                [self.reviewView.firstQuestionButton, self.reviewView.secondQuestionButton, self.reviewView.thirdQuestionButton, self.reviewView.fourthQuestionButton].forEach {
                    $0.isEnabled = false
                }
                self.reviewView.completeButton.isHidden = true
            } else {
                [self.reviewView.firstQuestionNumLabel, self.reviewView.secondQuestionNumLabel, self.reviewView.thirdQuestionNumLabel, self.reviewView.fourthQuestionNumLabel].forEach { $0.isHidden = true }
            }
        }
    }
    
    private func setupButton() {
        reviewView.firstQuestionButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        reviewView.secondQuestionButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        reviewView.thirdQuestionButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        reviewView.fourthQuestionButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        reviewView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func updateCompleteButton() {
        var isAnyButtonSelected = false
        
        if reviewView.firstQuestionView.layer.borderColor == UIColor.gadaeBlue.cgColor ||
            reviewView.secondQuestionView.layer.borderColor == UIColor.gadaeBlue.cgColor ||
            reviewView.thirdQuestionView.layer.borderColor == UIColor.gadaeBlue.cgColor ||
            reviewView.fourthQuestionView.layer.borderColor == UIColor.gadaeBlue.cgColor {
            isAnyButtonSelected = true
        }
        
        if isAnyButtonSelected {
            reviewView.completeButton.backgroundColor = .gadaeBlue
            reviewView.completeButton.isEnabled = true
        } else {
            reviewView.completeButton.backgroundColor = .lightGray
            reviewView.completeButton.isEnabled = false
        }
    }
}

// MARK: - @objc
extension ReviewViewController {
    @objc private func questionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            isSellerKindnessSelected.toggle()
            reviewView.firstQuestionView.layer.borderColor = isSellerKindnessSelected ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 2:
            isGoodNotificationSelected.toggle()
            reviewView.secondQuestionView.layer.borderColor = isGoodNotificationSelected ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 3:
            isDescriptionMatchSelected.toggle()
            reviewView.thirdQuestionView.layer.borderColor = isDescriptionMatchSelected ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 4:
            isArrivalSatisfactorySelected.toggle()
            reviewView.fourthQuestionView.layer.borderColor = isArrivalSatisfactorySelected ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        default:
            break
        }
        
        updateCompleteButton()
    }
    
    @objc private func completeButtonTapped() {
        guard /*let sellerId = self.sellerId,*/
            let purchaseFormId = self.purchaseFormId else { return }
        
        let sellerId = 521
        
        ReviewNetworkManager.shared.postReview(sellerId: sellerId,
                                               purchaseFormId: purchaseFormId,
                                               sellerKindness: self.isSellerKindnessSelected,
                                               goodNotification: self.isGoodNotificationSelected,
                                               arrivalSatisfactory: self.isArrivalSatisfactorySelected,
                                               descriptionMatch: self.isDescriptionMatchSelected) { error in
            let alertMessage: String
            
            if let error = error {
                print("리뷰 전송 실패: \(error.localizedDescription)")
                alertMessage = "이미 리뷰작성을 했습니다."
            } else {
                print("리뷰 전송 성공")
                alertMessage = "리뷰 작성이 완료되었습니다."
            }
            
            DispatchQueue.main.async() {
                self.navigationController?.popViewController(animated: true)
                self.showAlertWithDismissDelay(message: alertMessage)
            }
        }
    }
}
