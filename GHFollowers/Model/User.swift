//
//  User.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/8/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var htmlUrl: String
    var createdAt: String
}
    
    
  


   
