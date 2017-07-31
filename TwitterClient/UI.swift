//
//  InterfaceDesign.swift
//  TwitterClient
//
//  Created by Admin on 25/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UI {
    static let isIPad: Bool = {
        return UIDevice.current.userInterfaceIdiom == .pad
    }()
    
    static let hasLongSide: Bool = {
        if isIPad {
            return true
        }
        let screen = UIScreen.main.bounds
        if screen.width >= 667 || screen.height >= 667 { // or is iPhone 6/7 or bigger
            return true
        }
        return false
    }()
    
    static let profileImageSize: CGSize = {
        if isIPad {
            return CGSize(width: 70, height: 70)
        }
        return CGSize(width: 50, height: 50)
    }()
    
    static let profileImageCornerRadius: CGFloat = {
        if isIPad {
            return 35
        }
       return 25
    }()
    
    static let basicOffset = CGFloat(12)
    
    static let smallOffset = CGFloat(4)
    
    static let textFont: UIFont = {
        if isIPad {
            return UIFont.systemFont(ofSize: 20)
        }
        return UIFont.systemFont(ofSize: 15)
    }()
    
    static let separatorHeight = CGFloat(1)
    
    static let separatorColor = UIColor.twitterGray
    
    static var cellWidth: CGFloat {
        let screen = UIScreen.main.bounds.size
        var adjustment = CGFloat(0)
        if isIPad {
            adjustment = 120
            return screen.width < screen.height ?
                screen.width - adjustment : screen.height - adjustment
        }
        if hasLongSide {
            return screen.width < screen.height ? screen.width : screen.height
        }
        return screen.width
    }
    
    class ComposeVC {
        static let characterCountLabelTextColor = UIColor(white: 0.4, alpha: 1)
        static let characterCountLabelHeight = CGFloat(20)
    }
    
    class HomeVC {
        static let errorLabelWidth = CGFloat(200)
        static let spinnerBackgroundSize = CGSize.init(width: 120, height: 120)
        static let spinnerBackgroundColor = UIColor(white: 0.2, alpha: 1)
        static let spinnerBackgroundCornerRadius = CGFloat(10)
        static let widthPaddingForHeightEstimation: CGFloat = {
            if isIPad {
                return 12 + 70 + 12 + 2
            }
            return  12 + 50 + 12 + 2
        }()
        static let noTweetsCellHeigth = CGFloat(50)
    }
    
    class NavBar {
        static let buttonSize = CGSize(width: 34, height: 34)
    }
    
    class TweetCell {
        static let buttonSize = CGSize(width: 20, height: 20)
        static let heightPadding: CGFloat = {
            if isIPad {
                return 55
            }
            return 45
        }()
        static let textLineSpacing: CGFloat = {
            if isIPad {
                return 8
            }
            return 4
        }()
        static let nameFont: UIFont = {
            if isIPad {
                return UIFont.boldSystemFont(ofSize: 21)
            }
            return UIFont.boldSystemFont(ofSize: 16)
        }()
        static let screenNameFont: UIFont = {
            if isIPad {
                return UIFont.systemFont(ofSize: 20)
            }
            return UIFont.systemFont(ofSize: 15)
        }()
        static let counterFont = UIFont.systemFont(ofSize: 14)
        static var buttonViewMaxWidth: CGFloat {
            if isIPad {
                return 400
            }
            return 350
        }
    }
}
