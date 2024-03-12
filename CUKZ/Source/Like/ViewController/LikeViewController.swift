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
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupTableView()
    }
    
    private func prepare() {
        
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

