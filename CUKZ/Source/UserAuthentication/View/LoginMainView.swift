//
//  LoginMainView.swift
//  CUKZ
//
//  Created by 이승민 on 3/10/24.
//

import UIKit
import SnapKit
import Then

final class LoginMainView: UIView {
    // MARK: - View
    
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
       self.addSubviews([])
    }
    
    private func configureConstraints() {
        
    }
    
}
