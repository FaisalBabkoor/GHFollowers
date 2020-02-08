//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/8/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThrid(alertTitle: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: alertTitle, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
