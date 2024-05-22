//
//  UploadProductViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/27/24.
//

import UIKit

final class UploadProductViewController: UIViewController {
    // MARK: - Properties
    private let uploadProductView = UploadProductView()
    private var activeField: UIView?
    let statusArray = ["---- 선택 ----", "수요조사 중", "수요조사 종료", "공동구매 중", "공동구매 종료"]
    
    // MARK: - View 설정
    override func loadView() {
        view = uploadProductView
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTextField()
        setupTextView()
        setupButton()
        setupPickerView()
    }
    
    private func setupNaviBar() {
        title = "상품 등록"
    }
    
    private func setupTextField() {
        let view = uploadProductView
        view.productNameTextField.delegate = self
        view.statusTextField.delegate = self
        view.endDateTextField.delegate = self
    }
    
    private func setupTextView() {
        uploadProductView.desciptionTextView.delegate = self
    }
    
    private func setupButton() {
        uploadProductView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func setupPickerView() {
        uploadProductView.pickerView.dataSource = self
        uploadProductView.pickerView.delegate = self

        // 텍스트 필드의 입력 방식을 피커 뷰로 설정
        uploadProductView.statusTextField.inputView = uploadProductView.pickerView

        // 피커 뷰 위에 툴바 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(dismissPickerView))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        uploadProductView.statusTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - @objc
    @objc func dismissPickerView() {
        view.endEditing(true)
    }
    
    @objc private func completeButtonTapped() {
        print("작성완료 버튼 눌림")
    }
}

// MARK: - UITextFieldDelegate
extension UploadProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}

// MARK: - UITextViewDelegate
extension UploadProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
    }
}

// MARK: - 피커뷰
extension UploadProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusArray.count
    }
}

extension UploadProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(statusArray[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        uploadProductView.statusTextField.text = "\(statusArray[row])"
    }
}
