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
        reviewView.nicknameLabel.text = "\(data.nickname) 님의\n이런 점이 좋았어요"
        reviewView.firstQuestionNumLabel.text = "\(data.sellerKindnessCnt)"
        reviewView.secondQuestionNumLabel.text = "\(data.goodNotificationCnt)"
        reviewView.thirdQuestionNumLabel.text = "\(data.descriptionMatchCnt)"
        reviewView.fourthQuestionNumLabel.text = "\(data.arrivalSatisfactoryCnt)"
    }
    
    private func prepare() {
        if isLeave == false {
            [reviewView.firstQuestionButton, reviewView.secondQuestionButton, reviewView.thirdQuestionButton, reviewView.fourthQuestionButton].forEach {
                $0.isEnabled = false
            }
            reviewView.completeButton.isHidden = true
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
        // 각 버튼의 태그 값을 기반으로 해당 버튼의 질문 뷰의 테두리 색을 토글
        switch sender.tag {
        case 1:
            reviewView.firstQuestionView.layer.borderColor = (reviewView.firstQuestionView.layer.borderColor == UIColor.clear.cgColor) ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 2:
            reviewView.secondQuestionView.layer.borderColor = (reviewView.secondQuestionView.layer.borderColor == UIColor.clear.cgColor) ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 3:
            reviewView.thirdQuestionView.layer.borderColor = (reviewView.thirdQuestionView.layer.borderColor == UIColor.clear.cgColor) ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        case 4:
            reviewView.fourthQuestionView.layer.borderColor = (reviewView.fourthQuestionView.layer.borderColor == UIColor.clear.cgColor) ? UIColor.gadaeBlue.cgColor : UIColor.clear.cgColor
        default:
            break
        }
        
        updateCompleteButton()
    }
    
    @objc private func completeButtonTapped() {
        print("리뷰하기 버튼 눌림")
    }
}
