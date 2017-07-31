//
//  DirectMessageCoordinator.swift
//  TwitterClient
//
//  Created by Admin on 26/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DirectMessageCoordinator: Coordinator {
    public var completion: ((String?, Bool) -> ())?
    
    private let navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let composeVC = ComposeVC()
        composeVC.title = "Direct Message"
        composeVC.completion = completion
        composeVC.shouldLimitCharacters = false
        navigationController.pushViewController(composeVC, animated: true)
    }
}
