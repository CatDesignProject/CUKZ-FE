//
//  ProductHomeView.swift
//  CUKZ
//
//  Created by 이승민 on 3/16/24.
//

import UIKit

final class ProductHomeView: UIView {
    // MARK: - View
    let refreshControl = UIRefreshControl()
    
    let tableView = UITableView().then {
        $0.separatorInset.left = 20
        $0.separatorInset.right = 20
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func addViews() {
        self.addSubviews([
            tableView
        ])
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
