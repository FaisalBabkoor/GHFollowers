//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/6/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class GFTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12.0
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 2.0
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        
        placeholder = "Enter a username"
    }
    
}
