//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 5/3/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
