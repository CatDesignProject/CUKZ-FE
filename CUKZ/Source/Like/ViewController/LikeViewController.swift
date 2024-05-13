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
        setupRefresh()
    }
    
    // 네트워킹
    private func fetchData() {
        LikeNetworkManager.shared.getLikeAll(page: 1, size: 10) { model in
            if let model = model {
                self.totalPageNum = model.totalPage
                self.isLastPage = model.last
                self.arrayLike = model.content
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
        nb?.barTintColor = .white
        nb?.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = likeView.tableView
        
        tb.dataSource = self
        tb.delegate = self
        
        tb.rowHeight = 120
        tb.register(LikeCell.self, forCellReuseIdentifier: "LikeCell")
    }
    
    private func setupRefresh() {
        let rc = likeView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        likeView.tableView.refreshControl = rc
    }
}

// MARK: - @objc
extension LikeViewController {
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
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
        
        var productStatus: String = ""
        var productStatusColor: UIColor = .systemGray4
        
        switch data.status {
        case "ON_DEMAND":
            productStatus = "수요조사 중"
            productStatusColor = .systemPink
        case "END_DEMAND":
            productStatus = "수요조사 종료"
        case "ON_SALE":
            productStatus = "판매 중"
            productStatusColor = .systemBlue
        case "END_SALE":
            productStatus = "판매 종료"
        default:
            print("")
        }
        
        cell.productStateLabel.text = productStatus
        cell.productStateLabel.textColor = productStatusColor
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = ProductDetailViewController()
        VC.productId = arrayLike[indexPath.row].id // 아이디값 넘겨주기
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}
