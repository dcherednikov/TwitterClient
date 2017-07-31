//
//  AppCoordinatorDelegate.swift
//  TwitterClient
//
//  Created by Admin on 27/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

protocol AppCoordinatorDelegate {
    func replyConfirmed(_ reply: String, toTweet: Tweet)
    func newTweetConfirmed(_ text: String)
    func directMessageConfirmed(_ message: String, toUser: User)
}
