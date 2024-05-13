//
//  UIViewController+showAlertWithDismissDelay.swift
//  CUKZ
//
//  Created by 이승민 on 5/14/24.
//

import UIKit

extension UIViewController {
    func showAlertWithDismissDelay(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
