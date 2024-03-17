//
//  PurchseHomeViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/16/24.
//

import UIKit

final class PurchaseHomeViewController: UIViewController {
    // MARK: - Properties
    private let purchaseHomeView = PurchaseHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = purchaseHomeView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupCollectionView()
    }
    
    private func prepare() {
        
    }
    
    private func setupCollectionView() {
        purchaseHomeView.collectionView.dataSource = self
        purchaseHomeView.collectionView.delegate = self
        
        purchaseHomeView.collectionView.register(PurchaseHomeCell.self, forCellWithReuseIdentifier: "PurchaseHomeCell")
    }
    
}

// MARK: - UICollectionViewDataSource
extension PurchaseHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PurchaseHomeCell", for: indexPath) as! PurchaseHomeCell
        
        cell.thumnailImage.image = UIImage(named: "testImage2")
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PurchaseHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 10 * (itemsPerRow - 1) // 각 아이템 사이의 간격
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // 아이템 사이의 간격을 10 포인트로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // 행 사이의 간격을 10 포인트로 설정
    }
}

