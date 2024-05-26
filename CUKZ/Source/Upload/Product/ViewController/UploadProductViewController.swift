//
//  UploadProductViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/27/24.
//

import UIKit
import Photos
import PhotosUI

final class UploadProductViewController: UIViewController {
    // MARK: - Properties
    var imageList: [UIImage] = [] // 상품 사진 담는 배열
    var optionList: [Options] = [] // 옵션 담는 배열
    var isPatch: Bool = false // 상품 수정 여부
    var productId: Int? // 상품 수정할 때 필요

    private var activeField: UIView?
    let statusArray = ["---- 선택 ----", "수요조사 중", "수요조사 종료", "판매 중", "판매 종료"]
    
    let uploadProductView = UploadProductView()
    
    private let datePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()

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
        setupCollectionView()
    }
    
    private func setupNaviBar() {
        if isPatch {
            title = "상품 수정"
        } else {
            title = "상품 등록"
        }
        
    }
    
    // 텍스트필드 설정
    private func setupTextField() {
        let view = uploadProductView
        
        [view.productNameTextField,
         view.priceTextField,
         view.accountTextField,
         view.statusTextField,
         view.startDateTextField,
         view.endDateTextField].forEach { $0.delegate = self }

        setupDatePicker(for: view.startDateTextField, datePicker: datePicker)
        setupDatePicker(for: view.endDateTextField, datePicker: endDatePicker)
    }
    
    private func setupDatePicker(for textField: UITextField, datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.minimumDate = Date() // 현재 날짜 이전은 선택 불가하게 설정
        
        textField.inputView = datePicker

        // 피커 뷰 위에 툴바 추가
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(dismissPickerView))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        textField.inputAccessoryView = toolbar
    }
    
    // 텍스트뷰 설정
    private func setupTextView() {
        uploadProductView.descriptionTextView.delegate = self
    }
    
    // 버튼 설정
    private func setupButton() {
        uploadProductView.uploadImageView.addImageButton.addTarget(self, 
                                                                   action: #selector(addImageButtonTapped),
                                                                   for: .touchUpInside)
        
        uploadProductView.uploadOptionView.addOptionButton.addTarget(self,
                                                                     action: #selector(addOptionButtonTapped),
                                                                     for: .touchUpInside)
        
        uploadProductView.completeButton.addTarget(self, 
                                                   action: #selector(completeButtonTapped),
                                                   for: .touchUpInside)
    }
    
    // 피커뷰 설정
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
    
    // 컬렉션뷰 설정
    private func setupCollectionView() {
        // 사진
        uploadProductView.uploadImageView.collectionView.dataSource = self
        uploadProductView.uploadImageView.collectionView.register(UploadImageCell.self, forCellWithReuseIdentifier: "UploadImageCell")
        
        // 옵션
        uploadProductView.uploadOptionView.collectionView.dataSource = self
        uploadProductView.uploadOptionView.collectionView.register(UploadOptionCell.self, forCellWithReuseIdentifier: "UploadOptionCell")
    }
    
    // 작성완료 버튼 업데이트
    private func updateCompleteButtonState() {
        let isNameEmpty = uploadProductView.productNameTextField.text?.isEmpty ?? true
        let isPriceEmpty = uploadProductView.priceTextField.text?.isEmpty ?? true
        let isAccountEmpty = uploadProductView.accountTextField.text?.isEmpty ?? true
        let isStatusEmpty = uploadProductView.statusTextField.text?.isEmpty ?? true
        let isStatusValid = uploadProductView.statusTextField.text! == "---- 선택 ----"
        let isStartDateEmpty = uploadProductView.startDateTextField.text?.isEmpty ?? true
        let isEndDateEmpty = uploadProductView.endDateTextField.text?.isEmpty ?? true
        let isInfoEmpty = uploadProductView.descriptionTextView.text?.isEmpty ?? true
        let isImageEmpty = self.imageList.isEmpty
        
        if !isNameEmpty && !isPriceEmpty && !isAccountEmpty && !isStatusEmpty && !isStatusValid && !isStartDateEmpty && !isEndDateEmpty && !isInfoEmpty && !isImageEmpty {
            uploadProductView.completeButton.isEnabled = true
            uploadProductView.completeButton.backgroundColor = .gadaeBlue
        } else {
            uploadProductView.completeButton.isEnabled = false
            uploadProductView.completeButton.backgroundColor = .lightGray
        }
    }
}

// MARK: - @objc
extension UploadProductViewController {
    // 피커뷰 완료 버튼
    @objc private func dismissPickerView() {
        view.endEditing(true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if sender == datePicker {
            uploadProductView.startDateTextField.text = formatter.string(from: sender.date)
        } else if sender == endDatePicker {
            uploadProductView.endDateTextField.text = formatter.string(from: sender.date)
        }
    }

    // 사진추가 버튼
    @objc private func addImageButtonTapped() {
        print("사진 업로드 버튼 눌림")
        let availableSlots = 10 - imageList.count
        if availableSlots > 0 {
            var config = PHPickerConfiguration()
            config.filter = .images // 이미지만 보이게
            config.selectionLimit = availableSlots // 사진 갯수 제한
                    
            let imagePicker = PHPickerViewController(configuration: config)
            imagePicker.delegate = self
            imagePicker.modalPresentationStyle = .fullScreen
                    
            self.present(imagePicker, animated: true)
        } else {
            showAlertWithDismissDelay(message: "최대 10장까지 가능합니다.")
        }
    }
    
    // 사진삭제 버튼
    @objc func imageDeleteButtonTapped(sender: UIButton) {
        let index = sender.tag
        
        self.imageList.remove(at: index)
        print(self.imageList)
        self.uploadProductView.uploadImageView.collectionView.reloadData()
        
        updateCompleteButtonState() // 작성완료 버튼 업데이트
    }
    
    // 옵션추가 버튼
    @objc private func addOptionButtonTapped() {
        guard self.optionList.count < 10 else {
            self.showAlertWithDismissDelay(message: "최대 10개까지 가능합니다.")
            return
        }
        
        // 텍스트필드 alert 띄우기
        let alertController = UIAlertController(title: "옵션 추가", message: nil, preferredStyle: .alert)

        alertController.addTextField {
            $0.placeholder = "옵션 이름"
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }

        alertController.addTextField {
            $0.placeholder = "추가 가격"
            $0.keyboardType = .numberPad
        }

        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            guard let optionName = alertController.textFields?[0].text,
                  let additionalPriceText = alertController.textFields?[1].text,
                  let additionalPrice = Int(additionalPriceText), !optionName.isEmpty else {
                self.showAlertWithDismissDelay(message: "빈칸을 모두 입력해주세요.\n추가가격이 없을 시 0을 입력해주세요.")
                return
            }
            
            DispatchQueue.main.async {
                self.optionList.append(Options(name: optionName, additionalPrice: additionalPrice))
                self.uploadProductView.uploadOptionView.collectionView.reloadData()
                print("옵션 추가 --- \(self.optionList)")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(addAction)

        present(alertController, animated: true, completion: nil)
    }

    
    // 옵션삭제 버튼
    @objc func optionDeleteButtonTapped(sender: UIButton) {
        let index = sender.tag
        
        self.optionList.remove(at: index)
        print("옵션 삭제 --- \(self.optionList)")
        self.uploadProductView.uploadOptionView.collectionView.reloadData()
        
        updateCompleteButtonState() // 작성완료 버튼 업데이트
    }
    
    // 작성완료 버튼
    @objc private func completeButtonTapped() {
        ProductNetworkManager.shared.uploadImage(images: self.imageList) { result in
            switch result {
            case .success(let imageIds): // 이미지 업로드에 성공 후, 상품 등록
                print("업로드된 이미지 IDs: \(imageIds)")
                
                guard let name = self.uploadProductView.productNameTextField.text,
                      let price = self.uploadProductView.priceTextField.text,
                      let sellerAccount = self.uploadProductView.accountTextField.text,
                      var status = self.uploadProductView.statusTextField.text,
                      let startDateText = self.uploadProductView.startDateTextField.text,
                      let endDateText = self.uploadProductView.endDateTextField.text,
                      let info = self.uploadProductView.descriptionTextView.text else { return }
                
                switch status {
                case "수요조사 중":
                    status = "ON_DEMAND"
                case "수요조사 종료" :
                    status = "END_DEMAND"
                case "판매 중":
                    status = "ON_SALE"
                case "판매 종료":
                    status = "END_SALE"
                default:
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                let startDateFormatter = DateFormatter()
                startDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:01"

                let endDateFormatter = DateFormatter()
                endDateFormatter.dateFormat = "yyyy-MM-dd'T'00:50:59"

                guard let startDate = formatter.date(from: startDateText),
                      let endDate = formatter.date(from: endDateText) else {
                    print("날짜 형식 오류")
                    return
                }

                let formattedStartDate = startDateFormatter.string(from: startDate)
                let formattedEndDate = endDateFormatter.string(from: endDate)
                
                let parameters = UploadProductRequest(
                    name: name,
                    price: Int(price) ?? 0,
                    sellerAccount: sellerAccount,
                    status: status,
                    startDate: formattedStartDate,
                    endDate: formattedEndDate,
                    info: info,
                    productImageIds: imageIds,
                    options: self.optionList
                )
                
                print(parameters)
                
                if self.isPatch { // 상품 수정일 때
                    guard let productId = self.productId else { return }
                    
                    ProductNetworkManager.shared.patchProduct(productId: productId,
                                                              parameters: parameters) { error in
                        if let error = error {
                            print("상품 수정 실패: \(error.localizedDescription)")
                        } else {
                            print("상품 수정 성공")
                            if let productDetailVC = self.navigationController?.viewControllers.first(where: { $0 is ProductDetailViewController }) as? ProductDetailViewController {
                                self.navigationController?.popViewController(animated: true)
                                productDetailVC.fetchData()
                            }
                        }
                    }
                } else { // 상품 등록일 때
                    ProductNetworkManager.shared.uploadProduct(parameters: parameters) { error in
                        if let error = error {
                            print("상품 등록 실패: \(error.localizedDescription)")
                        } else {
                            print("상품 등록 성공")
                            if let productHomeVC = self.navigationController?.viewControllers.first(where: { $0 is ProductHomeViewController }) as? ProductHomeViewController {
                                self.navigationController?.popViewController(animated: true)
                                productHomeVC.fetchData()
                            }
                        }
                    }
                }
            case .failure(let error):
                print("이미지 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension UploadProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateCompleteButtonState() // 텍스트필드 입력이 끝날때 마다 작성완료 버튼 업데이트
    }
}

// MARK: - UITextViewDelegate
extension UploadProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
        updateCompleteButtonState() // 텍스트뷰 입력이 끝날때 마다 작성완료 버튼 업데이트
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

// MARK: - UICollectionViewDataSource
extension UploadProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == uploadProductView.uploadImageView.collectionView {
            return self.imageList.count
        } else {
            return self.optionList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == uploadProductView.uploadImageView.collectionView { // 사진
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
            
            let image = self.imageList[indexPath.item]
            cell.uploadedImageView.image = image
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, 
                                        action: #selector(imageDeleteButtonTapped),
                                        for: .touchUpInside)
            return cell
            
        } else { // 옵션
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadOptionCell", for: indexPath) as! UploadOptionCell
            
            let data = self.optionList[indexPath.row]
            cell.optionNameLabel.text = data.name
            cell.additionalPrice.text = "+ \(data.additionalPrice)"
            cell.deleteButton.addTarget(self,
                                        action: #selector(optionDeleteButtonTapped),
                                        for: .touchUpInside)
            return cell
        }
        
        
    }
}

// MARK: - PHPickerViewControllerDelegate
extension UploadProductViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else {
                    return
                }

                DispatchQueue.main.async {
                    self?.imageList.append(image)
                    self?.uploadProductView.uploadImageView.collectionView.reloadData()
                    self?.updateCompleteButtonState() // 작성완료 버튼 업데이트
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
