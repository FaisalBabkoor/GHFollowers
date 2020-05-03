//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 4/29/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

protocol FollowerItemVCDelegate: class {
    func didTapFollowers(user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: FollowerItemVCDelegate!
    
    
    init(user: User, delegate: FollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapFollowers(user: user)
    }
}
