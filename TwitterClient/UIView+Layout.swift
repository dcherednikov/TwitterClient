//
//  UIView+layout.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor?,
                topConstant: CGFloat?,
                leftAnchor: NSLayoutXAxisAnchor?,
                leftConstant: CGFloat?,
                bottomAnchor: NSLayoutYAxisAnchor?,
                bottomConstant: CGFloat?,
                rightAnchor: NSLayoutXAxisAnchor?,
                rightConstant: CGFloat?,
                widthConstant: CGFloat?,
                heightConstant: CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor,
                                      constant: topConstant ?? 0).isActive = true
        }
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor,
                                       constant: leftConstant ?? 0).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            let reversedConstant = 0 - (bottomConstant ?? 0)
            self.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: reversedConstant).isActive = true
        }
        if let rightAnchor = rightAnchor {
            let reversedConstant = 0 - (rightConstant ?? 0)
            self.rightAnchor.constraint(equalTo: rightAnchor,
                                        constant: reversedConstant).isActive = true
        }
        if let widthConstant = widthConstant {
            self.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if let heightConstant = heightConstant {
            self.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
    func center(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
