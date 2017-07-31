//
//  Tweet+PrettyPrint.swift
//  TwitterClient
//
//  Created by Admin on 27/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


extension Tweet {
    func prettyPrint() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [NSFontAttributeName: UI.TweetCell.nameFont])
        let screenName = "  \(user.screenName)\n"
        attributedText.append(NSAttributedString(string: screenName,
                                                 attributes: [NSFontAttributeName: UI.TweetCell.screenNameFont, NSForegroundColorAttributeName: UIColor.gray]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = UI.TweetCell.textLineSpacing
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName,
                                    value: paragraphStyle,
                                    range: range)
        
        attributedText.append(NSAttributedString(string: text,
                                                 attributes:[NSFontAttributeName: UI.textFont]))
        
        return attributedText
    }
}
