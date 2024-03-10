//
//  UIStackView+addArrangedSubviews.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
