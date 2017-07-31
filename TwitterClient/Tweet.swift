//
//  Tweet.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

struct Tweet: DescriptionDecodable {
    let id: Int64
    let user: User
    let text: String
    
    var favorited: Bool
    var retweeted: Bool
    var favoriteCount: Int
    var retweetCount: Int
    
    init(description: [String: AnyObject]) {
        let userDescription = description["user"]
        user = User(description: userDescription as? [String : AnyObject] ?? ["": "" as AnyObject])
        text = description["text"] as? String ?? ""
        id = description["id"] as? Int64 ?? 0
        favorited = description["favorited"] as? Bool ?? false
        retweeted = description["retweeted"] as? Bool ?? false
        favoriteCount = description["favorite_count"] as? Int ?? 0
        retweetCount = description["retweet_count"] as? Int ?? 0
    }
}
