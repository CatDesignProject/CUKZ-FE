//
//  UITableView+EmptyView.swift
//  CUKZ
//
//  Created by 이승민 on 5/14/24.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .gadaeBlue
            label.numberOfLines = 0;
            label.textAlignment = .center;
            label.font = .boldSystemFont(ofSize: 17)
            label.sizeToFit()
            return label
        }()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

