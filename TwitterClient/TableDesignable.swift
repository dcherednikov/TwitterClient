//
//  TableDesignable.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


protocol TableDesignable {
    func addSeparator()
}

extension TableDesignable where Self: UIView {    
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = UI.separatorColor

        addSubview(separator)
        
        separator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separator.anchor(topAnchor: nil,
                         topConstant: nil,
                         leftAnchor: UI.hasLongSide ? nil : leftAnchor,
                         leftConstant: 0,
                         bottomAnchor: bottomAnchor,
                         bottomConstant: 0,
                         rightAnchor: UI.hasLongSide ? nil : rightAnchor,
                         rightConstant: 0,
                         widthConstant: UI.hasLongSide ? UI.cellWidth : nil,
                         heightConstant: UI.separatorHeight)
    }
}
