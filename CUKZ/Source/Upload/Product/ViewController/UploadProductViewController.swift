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
    private var imageList: [UIImage] = []

    private var activeField: UIView?
    let statusArray = ["---- 선택 ----", "수요조사 중", "수요조사 종료", "판매 중", "판매 종료"]
    
    private let uploadProductView = UploadProductView()
    
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
        title = "상품 등록"
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
    }
    
    // 텍스트뷰 설정
    private func setupTextView() {
        uploadProductView.descriptionTextView.delegate = self
    }
    
    // 버튼 설정
    private func setupButton() {
        uploadProductView.uploadImageView.uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        uploadProductView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
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
        uploadProductView.uploadImageView.collectionView.dataSource = self
        uploadProductView.uploadImageView.collectionView.register(UploadImageCell.self, forCellWithReuseIdentifier: "UploadImageCell")
    }
}

// MARK: - @objc
extension UploadProductViewController {
    @objc private func dismissPickerView() {
        view.endEditing(true)
    }

    @objc private func uploadButtonTapped() {
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
            showAlertWithDismissDelay(message: "이미지는 최대 10장까지만 업로드 가능합니다.")
        }
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        let index = sender.tag
        
        self.imageList.remove(at: index)
        print(self.imageList)
        self.uploadProductView.uploadImageView.collectionView.reloadData()
    }
    
    @objc private func completeButtonTapped() {
        ProductNetworkManager.shared.uploadImage(images: self.imageList) { result in
            switch result {
            case .success(let imageIds): // 이미지 업로드에 성공 후, 상품 등록
                print("업로드된 이미지 IDs: \(imageIds)")
                
                guard let name = self.uploadProductView.productNameTextField.text,
                      let price = self.uploadProductView.priceTextField.text,
                      let sellerAccount = self.uploadProductView.accountTextField.text,
                      var status = self.uploadProductView.statusTextField.text,
                      let startDate = self.uploadProductView.startDateTextField.text,
                      let endDate = self.uploadProductView.endDateTextField.text,
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
                
                let parameters = UploadProductRequest(
                    name: name,
                    price: Int(price) ?? 0,
                    sellerAccount: sellerAccount,
                    status: status,
                    startDate: startDate,
                    endDate: endDate,
                    info: info,
                    productImageIds: imageIds,
                    options: []
                )
                
                print(parameters)
                
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

// MARK: - UICollectionViewDataSource
extension UploadProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
        
        let image = self.imageList[indexPath.item]
        cell.uploadedImageView.image = image
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
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
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
