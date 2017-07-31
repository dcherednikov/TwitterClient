//
//  Service.swift
//  TwitterClient
//
//  Created by Admin on 23/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import STTwitter

class Service {    
    private let twitter: STTwitterAPI? = {
        let plist = Bundle.main.path(forResource: "Keychain", ofType: "plist")
        let keychain = NSDictionary(contentsOfFile: plist!)!
        
        let twitter = STTwitterAPI(oAuthConsumerKey: keychain["consumer_key"] as! String,
                                   consumerSecret: keychain["consumer_secret"] as! String,
                                   oauthToken: keychain["access_token"] as! String,
                                   oauthTokenSecret: keychain["access_token_secret"] as! String)

        return twitter
    }()
    
    public func verifyCredentials(successBlock: @escaping () -> (),
                                  errorBlock: @escaping (Error?) ->()) {
        twitter?.verifyCredentials(userSuccessBlock: { (username, userId) in
            successBlock()
        }, errorBlock: { (error) in
            errorBlock(error)
        })
    }
    
    public func fetchHomeTimeline(successBlock: @escaping ([Any]?) -> (),
                                  errorBlock: @escaping (Error?) -> ()) {
        let _ = twitter?.getHomeTimeline(sinceID: nil,
                                         count: 10,
                                         successBlock: successBlock,
                                         errorBlock: errorBlock)
    }
    
    public func fetchHomeTimelineSinceTweet(_ tweet: Tweet,
                                            successBlock: @escaping ([Any]?) -> (),
                                            errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = "\(tweet.id)"
        let _ = twitter?.getHomeTimeline(sinceID: tweetIdString,
                                         count: 1,
                                         successBlock: successBlock,
                                         errorBlock: errorBlock)
    }
    
    public func like(tweet: Tweet,
                     successBlock: @escaping (Any?) -> (),
                     errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = "\(tweet.id)"
        let _ = twitter?.postFavoriteState(true,
                                           forStatusID: tweetIdString,
                                           successBlock: successBlock,
                                           errorBlock: errorBlock)
    }
    
    public func unlike(tweet: Tweet,
                       successBlock: @escaping (Any?) -> (),
                       errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = "\(tweet.id)"
        let _ = twitter?.postFavoriteState(false,
                                           forStatusID: tweetIdString,
                                           successBlock: successBlock,
                                           errorBlock: errorBlock)
    }
    
    public func tweet(_ text: String,
                      successBlock: @escaping (Any?) -> (),
                      errorBlock: @escaping (Error?) -> ()) {
        let _ = twitter?.postStatusUpdate(text,
                                          inReplyToStatusID: nil,
                                          latitude: nil,
                                          longitude: nil,
                                          placeID: nil,
                                          displayCoordinates: NSNumber(value: false),
                                          trimUser: NSNumber(value: false),
                                          successBlock: successBlock,
                                          errorBlock: errorBlock)
    }
    
    public func reply(_ text: String,
                      toTweet tweet: Tweet,
                      successBlock: @escaping (Any?) -> (),
                      errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = String("\(tweet.id)")
        let reply = "@\(tweet.user.screenName) " + text
        print(tweetIdString!)
        let _ = twitter?.postStatusUpdate(reply,
                                          inReplyToStatusID: tweetIdString,
                                          latitude: nil,
                                          longitude: nil,
                                          placeID: nil,
                                          displayCoordinates: NSNumber(value: false),
                                          trimUser: NSNumber(value: false),
                                          successBlock: successBlock,
                                          errorBlock: errorBlock)
    }
    
    public func retweet(_ tweet: Tweet,
                        successBlock: @escaping (Any?) -> (),
                        errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = "\(tweet.id)"
        let _ = twitter?.postStatusRetweet(withID: tweetIdString,
                                           successBlock: successBlock,
                                           errorBlock: errorBlock)
    }
    
    public func unretweet(_ tweet: Tweet,
                          successBlock: @escaping (Any?) -> (),
                          errorBlock: @escaping (Error?) -> ()) {
        let tweetIdString = "\(tweet.id)"
        let _ = twitter?.postStatusUnretweet(withID: tweetIdString,
                                             trimUser: NSNumber(value: false),
                                             successBlock: successBlock,
                                             errorBlock: errorBlock)
    }
    
    public func sendMessage(_ message: String,
                            toUser user: User,
                            successBlock: @escaping (Any?) -> (),
                            errorBlock: @escaping (Error?) -> ()) {        
        let _ = twitter?.postDirectMessage(message,
                                           forScreenName: user.screenName,
                                           orUserID: nil,
                                           successBlock: successBlock,
                                           errorBlock: errorBlock)
    }
    
    private var imageCache = NSCache<NSString, DiscardableImage>()
    
    public func loadImageForUser(_ user: User,
                                  completion: @escaping (UIImage) -> ()) {
        let urlKey = user.profileImageUrl as NSString
        
        if let cachedItem = imageCache.object(forKey: urlKey) {
            let image = cachedItem.image ?? #imageLiteral(resourceName: "default_profile_image")
            completion(image)
            return
        }
        
        guard let url = URL(string: user.profileImageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }

            if let image = UIImage(data: data!) {
                let cacheItem = DiscardableImage(image: image)
                self.imageCache.setObject(cacheItem, forKey: urlKey)
                        completion(image)
            }
        }).resume()
    }
}
