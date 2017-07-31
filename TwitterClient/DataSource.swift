//
//  DataSource.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation


class DataSource {
    private var tweets = [Tweet]()
    
    public func receiveTweetsData(_ statuses: [Any]?) {
        tweets.removeAll()
        guard checkStatuesValid(statuses) else {
            return
        }
        for status in statuses! {
            let tweet = Tweet(description: status as! [String : AnyObject])
            tweets.append(tweet)
        }
    }
    
    public func insertNewTweets(_ statuses: [Any]?) {
        guard checkStatuesValid(statuses) else {
            return
        }
        
        guard let newTweets = statuses?.map({ (status) -> Tweet in
            return Tweet(description: status as! [String : AnyObject])
        }) else {
            return
        }

        tweets.insert(contentsOf: newTweets, at: 0)
    }
    
    private func checkStatuesValid(_ statuses: [Any]?) -> Bool {
        for status in statuses! {
            guard let status = status as? [String: Any] else {
                return false
            }
            guard let _ = status["text"] else {
                return false
            }
            guard let _ = status["user"] else {
                return false
            }
        }
        return true
    }
    
    subscript(indexPath: IndexPath) -> Any {
        return tweets[indexPath.row]
    }
    
    public func numberOfSections() -> Int {
        return 1
    }
    
    public func numberOfItems(inSection section: Int) -> Int {
        return tweets.count
    }
    
    public func markTweetFavorited(index: Int, favorited: Bool) {
        if favorited == tweets[index].favorited {
            return
        }
        tweets[index].favorited = favorited
        if favorited {
            tweets[index].favoriteCount += 1
        }
        else {
            tweets[index].favoriteCount -= 1
        }
    }
    
    public func markTweetRetweeted(index: Int, retweeted: Bool) {
        if retweeted == tweets[index].retweeted {
            return
        }
        tweets[index].retweeted = retweeted
        if retweeted {
            tweets[index].retweetCount += 1
        }
        else {
            tweets[index].retweetCount -= 1
        }
    }
}
