//
//  User.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let screenName: String
    let bioText: String
    let profileImageUrl: String
    let following: Bool
    
    init(description: [String: AnyObject]) {
        name = description["name"] as? String ?? ""
        screenName = description["screen_name"] as? String ?? ""
        bioText = description["description"] as? String ?? ""
        let fullProfileImageUrl = description["profile_image_url_https"] as? String ?? ""
        profileImageUrl = fullProfileImageUrl.replacingOccurrences(of: "_normal", with: "")
        following = description["following"] as? Bool ?? false
    }
}
