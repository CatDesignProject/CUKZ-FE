//
//  LikeViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/12/24.
//

import UIKit
import Kingfisher

final class LikeViewController: UIViewController {
    // MARK: - Properties
    var arrayLike: [LikeAllModel.Content] = []
    var totalPageNum: Int = 0
    var pageNum: Int = 0
    var isLastPage: Bool = false
    
    private let likeView = LikeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = likeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTableView()
    }
    
    // 네트워킹
    private func fetchData() {
        LikeNetworkManager.shared.getLikeAll(page: 1, size: 10) { model in
            if let model = model {
                self.totalPageNum = model.body.totalPage
                self.isLastPage = model.body.last
                self.arrayLike = model.body.content
                DispatchQueue.main.async {
                    self.likeView.tableView.reloadData()
                }
            }
        }
    }
    
    // 네비게이션바 설정
    private func setupNaviBar() {
        title = "좋아요"
        
        let nb = navigationController?.navigationBar
        nb?.prefersLargeTitles = true
        nb?.barTintColor = .white
        nb?.tintColor = .black
    }
    
    // 테이블뷰 설정
    func setupTableView() {
        let tb = likeView.tableView
        
        tb.dataSource = self
        tb.delegate = self
        
        tb.rowHeight = 120
        tb.register(LikeCell.self, forCellReuseIdentifier: "LikeCell")
    }
}

// MARK: - UITableViewDataSource
extension LikeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLike.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCell", for: indexPath) as! LikeCell
        
        let data = arrayLike[indexPath.row]
        
        if let imageUrlString = data.imageUrls.first,
           let imageUrl = URL(string: imageUrlString) {
            cell.thumnailImage.kf.setImage(with: imageUrl)
        }
        cell.productNameLabel.text = data.name
        cell.productPriceLabel.text = "\(data.price)원"
        
        var saleStatus = ""
        
        switch data.status {
        case "ON_DEMAND":
            saleStatus = "수요조사 중"
        case "END_DEMAND":
            saleStatus = "수요조사 종료"
        case "ON_SALE":
            saleStatus = "판매 중"
        case "END_SALE":
            saleStatus = "판매 종료"
        default:
            print("")
        }
        
        cell.productStateLabel.text = saleStatus
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LikeViewController: UITableViewDelegate {
    
}
