//
//  LikeViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/12/24.
//

import UIKit

final class LikeViewController: UIViewController {
    // MARK: - Properties
    private let likeView = LikeView()
    
    // MARK: - View 설정
    override func loadView() {
        view = likeView
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupNaviBar()
        setupTableView()
    }
    
    private func prepare() {
        
    }
    
    private func setupNaviBar() {
        title = "좋아요"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupTableView() {
        let tb = likeView.tableView
        
        tb.dataSource = self
        tb.delegate = self
        
        tb.rowHeight = 120
        tb.register(LikeCell.self, forCellReuseIdentifier: "LikeCell")
    }
}

extension LikeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCell", for: indexPath) as! LikeCell
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension LikeViewController: UITableViewDelegate {
    
}

