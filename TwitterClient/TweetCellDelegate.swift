//
//  TweetCellDelegate.swift
//  TwitterClient
//
//  Created by Admin on 25/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

protocol TweetCellDelegate: class {
    func replyButtonPressed(cell: TweetCell)
    func retweetButtonPressed(cell: TweetCell)
    func unretweetButtonPressed(cell: TweetCell)
    func likeButtonPressed(cell: TweetCell)
    func unlikeButtonPressed(cell: TweetCell)
    func directMessageButtonPressed(cell: TweetCell)
}
