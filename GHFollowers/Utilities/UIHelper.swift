//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/10/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class UIHelper {
    static func creatThreeColumnFolowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let column: CGFloat = 3.0
        let width = view.bounds.width
        let padding: CGFloat = 12.0
        let minimumItemSpacing: CGFloat = 10.0
        let avalibleWidth = width - (padding * 2) - (minimumItemSpacing * (column - 1))
        let itemWidth = avalibleWidth / column
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
}
