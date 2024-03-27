//
//  PurchseHomeViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/16/24.
//

import UIKit

// MARK: - 더미데이터
let testArray1 = [UIImage(named: "testImage"), UIImage(named: "testImage2"), UIImage(named: "testImage2"), UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage2"), UIImage(named: "testImage2"), UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage2"), UIImage(named: "testImage2")]

let testArray2 = ["컴공 과잠 사실분 와주십시오", "굿즈 공동구매 많은 참여 부탁드립니다!", "굿즈 공동구매 많은 참여 부탁드립니다!", "컴공 과잠 사실분 와주십시오", "컴공 과잠 사실분 와주십시오", "굿즈 공동구매 많은 참여 부탁드립니다!", "굿즈 공동구매 많은 참여 부탁드립니다!", "컴공 과잠 사실분 와주십시오", "컴공 과잠 사실분 와주십시오", "굿즈 공동구매 많은 참여 부탁드립니다!", "굿즈 공동구매 많은 참여 부탁드립니다!"]

final class ProductHomeViewController: UIViewController {
    // MARK: - Properties
    private let productHomeView = ProductHomeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = productHomeView
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupNaviBar()
        setupCollectionView()
    }
    
    private func prepare() {
        
    }
    
    private func setupNaviBar() {
        title = "상품"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .gadaeBlue
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "상품 검색"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writingButtonTapped))
    }
    
    @objc func writingButtonTapped() {
        print("구매하기 글쓰기 버튼 눌림")
    }
    
    private func setupCollectionView() {
        productHomeView.collectionView.dataSource = self
        productHomeView.collectionView.delegate = self
        
        productHomeView.collectionView.register(ProductHomeCell.self, forCellWithReuseIdentifier: "ProductHomeCell")
    }
    
}

// MARK: - UICollectionViewDataSource
extension ProductHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHomeCell", for: indexPath) as! ProductHomeCell
        
        if indexPath.row == 3 {
            cell.backView.backgroundColor = .black
            cell.backView.layer.opacity = 0.2
            cell.endLabel.isHidden = false
        } else {
            cell.backView.backgroundColor = .clear
            cell.backView.layer.opacity = 1.0
            cell.endLabel.isHidden = true
        }
        
        cell.thumnailImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width / 2)
        }
        cell.thumnailImage.image = testArray1[indexPath.row]
        cell.titleLabel.text = testArray2[indexPath.row]
        cell.priceLabel.text = "19000원"
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.width / 2
        
        return CGSize(width: size, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 아이템 사이의 간격
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35 // 행 사이의 간격
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let VC = ProductDetailViewController()
        VC.hidesBottomBarWhenPushed = true // 탭 바 숨기기
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
