//
//  HomeVC+navbar.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


extension HomeVC {
    public func setupNavigationBarItems() {
        setupCenterNavItem()
        setupRightNavsItems()
        setupNavBarSeparator()
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupCenterNavItem() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "title_icon"))
        var frame = CGRect()
        frame.size = UI.NavBar.buttonSize
        titleImageView.frame = frame
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
    }
    
    private func setupRightNavsItems() {
        let composeButton = UIButton()
        composeButton.setImage(#imageLiteral(resourceName: "compose").withRenderingMode(.alwaysOriginal), for: .normal)
        var frame = CGRect()
        frame.size = UI.NavBar.buttonSize
        composeButton.frame = frame
        composeButton.addTarget(self,
                                action: #selector(composeButtonPressed),
                                for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeButton)
    }
    
    private func setupNavBarSeparator() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UI.separatorColor
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.addSubview(separatorView)
        
        separatorView.anchor(topAnchor: nil,
                             topConstant: nil,
                             leftAnchor: navigationBar.leftAnchor,
                             leftConstant: 0,
                             bottomAnchor: navigationBar.bottomAnchor,
                             bottomConstant: 0,
                             rightAnchor: navigationBar.rightAnchor,
                             rightConstant: 0,
                             widthConstant: nil,
                             heightConstant: UI.separatorHeight)
    }
}
