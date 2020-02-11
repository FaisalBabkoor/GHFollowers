//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/10/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholder = #imageLiteral(resourceName: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        image = placeholder
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
