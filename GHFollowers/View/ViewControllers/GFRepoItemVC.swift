//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 4/29/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

protocol RepoItemVCDelegate: class {
    func didTapGitHubProfile(user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: RepoItemVCDelegate!
    
    
    init(user: User, delegate: RepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(user: user)
    }
}

