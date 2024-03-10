//
//  UIView+addSubViews.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
