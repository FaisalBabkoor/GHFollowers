//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 5/1/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseIdentifier = "FavoriteCell"
    
    let avatarImage = GFAvatarImageView(frame: .zero)
    let username = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(favorite: Follower) {
        self.username.text = favorite.login
        self.avatarImage.downloadImage(from: favorite.avatarUrl)
    }
    
    
    private func configure() {
        addSubview(avatarImage)
        addSubview(username)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            
            username.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            username.leadingAnchor.constraint(equalTo: self.avatarImage.trailingAnchor, constant: 24),
            username.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            username.heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
}
