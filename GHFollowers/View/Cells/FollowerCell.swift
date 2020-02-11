//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/10/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseIdentifire = "FollowerCell"
    
    let avatarImage = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(follower: Follower) {
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] (image) in
            guard let self = self else { return }
            self.avatarImage.image = image
        }
        usernameLabel.text = follower.login
    }
    
    
    func configure() {
        addSubview(avatarImage)
        addSubview(usernameLabel)
        
        let padding: CGFloat = 12.0
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
