//
//  AppCoordinator.swift
//  TwitterClient
//
//  Created by Admin on 26/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var childCoordinators: [String: Coordinator] = [String: Coordinator]()
    private let homeVC = HomeVC()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        homeVC.replyRequestBlock = { [unowned self](tweet) in
            self.showReplyCompose(toTweet: tweet)
        }
        homeVC.composeRequestBlock =  { [unowned self] in
            self.showTweetCompose()
        }
        homeVC.directMessageRequestBlock = { [unowned self](user) in
            self.showDirectMessageCompose(toUser: user)
        }
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func showReplyCompose(toTweet tweet: Tweet) {
        let coordinator = ReplyCoordinator(navigationController)
        let key = "reply"
        childCoordinators[key] = coordinator
        coordinator.completion = { [unowned self](reply, confirmed) in
            if confirmed, let reply = reply {
                self.homeVC.replyConfirmed(reply, toTweet: tweet)
            }
            self.childCoordinators.removeValue(forKey: key)
        }
        coordinator.start()
    }
    
    
    func showTweetCompose() {
        let coordinator = ComposeCoordinator(navigationController)
        let key = "compose"
        childCoordinators[key] = coordinator
        coordinator.completion = { [unowned self](text, confirmed) in
            if confirmed, let text = text {
                self.homeVC.newTweetConfirmed(text)
            }
            self.childCoordinators.removeValue(forKey: key)
        }
        coordinator.start()
    }
    
    func showDirectMessageCompose(toUser user: User) {
        let coordinator = DirectMessageCoordinator(navigationController)
        let key = "direct_message"
        childCoordinators[key] = coordinator
        coordinator.completion = { [unowned self](message, confirmed) in
            if confirmed, let message = message  {
                self.homeVC.directMessageConfirmed(message, toUser: user)
            }
            self.childCoordinators.removeValue(forKey: key)
        }
        coordinator.start()
    }
}
