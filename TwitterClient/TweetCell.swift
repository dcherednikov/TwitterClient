//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell, TableDesignable {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public weak var delegate: TweetCellDelegate?
    
    public var tweetInfo: Tweet? {
        didSet {
            guard let tweet = tweetInfo else {
                return
            }
            
            let attributedText = tweet.prettyPrint()
            messageTextView.attributedText = attributedText
            
            likeButton.isHighlighted = tweet.favorited
            retweetButton.isHighlighted = tweet.retweeted
            if !tweet.user.following {
                directMessageButton.alpha = 0.2
            }
            else {
                directMessageButton.alpha = 1
            }
            
            likeCountLabel.text = stringForNumber(number: tweet.favoriteCount)
            retweetCountLabel.text = stringForNumber(number: tweet.retweetCount)
        }
    }
    
    public var profileImage: UIImage? {
        didSet {
            profileImageView.image = profileImage
        }
    }
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Some sample text"
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = UI.profileImageCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "retweet").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "retweet_green").withRenderingMode(.alwaysOriginal), for: .highlighted)
        return button
    }()
    
    private let retweetCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.twitterLightGray
        label.font = UI.TweetCell.counterFont
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "like_red").withRenderingMode(.alwaysOriginal), for: .highlighted)
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.twitterLightGray
        label.font = UI.TweetCell.counterFont
        return label
    }()
    
    private let directMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send_message").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - view setup
    func setupViews() {
        backgroundColor = .white
        
        addViews()
        anchorViews()
        addSeparator()
        setupBottomButtons()
    }
    
    func setupActions() {
        replyButton.addTarget(self,
                              action: #selector(replyButtonPressed),
                              for: .touchUpInside)
        retweetButton.addTarget(self,
                                action: #selector(retweetButtonPressed),
                                for: .touchUpInside)
        likeButton.addTarget(self,
                             action: #selector(likeButtonPressed),
                             for: .touchUpInside)
        directMessageButton.addTarget(self,
                                      action: #selector(directMessageButtonPressed),
                                      for: .touchUpInside)
    }
    
    private func addViews() {
        addSubview(containerView)
        addSubview(profileImageView)
        addSubview(messageTextView)
    }
    
    private func anchorViews() {
        containerView.center(inView: self)
        containerView.anchor(topAnchor: topAnchor,
                             topConstant: 0,
                             leftAnchor: UI.hasLongSide ? nil : leftAnchor,
                             leftConstant: 0,
                             bottomAnchor: bottomAnchor,
                             bottomConstant: 0,
                             rightAnchor: UI.hasLongSide ? nil : rightAnchor,
                             rightConstant: 0,
                             widthConstant: UI.hasLongSide ? UI.cellWidth : nil,
                             heightConstant: 0)
        
        profileImageView.anchor(topAnchor: containerView.topAnchor,
                                topConstant: UI.basicOffset,
                                leftAnchor: containerView.leftAnchor,
                                leftConstant: UI.basicOffset,
                                bottomAnchor: nil,
                                bottomConstant: nil,
                                rightAnchor: nil,
                                rightConstant: nil,
                                widthConstant: UI.profileImageSize.width,
                                heightConstant: UI.profileImageSize.height)
        
        messageTextView.anchor(topAnchor: containerView.topAnchor,
                               topConstant: UI.smallOffset,
                               leftAnchor: profileImageView.rightAnchor,
                               leftConstant: UI.smallOffset,
                               bottomAnchor: containerView.bottomAnchor,
                               bottomConstant: 0,
                               rightAnchor: containerView.rightAnchor,
                               rightConstant: 0,
                               widthConstant: nil,
                               heightConstant: nil)
    }
    
    private func setupBottomButtons() {
        let replyButtonContainerView = UIView()
        let retweetButtonContainerView = UIView()
        let likeButtonContainerView = UIView()
        let directMessageButtonContainerView = UIView()
        
        let buttonStackView = UIStackView(arrangedSubviews: [replyButtonContainerView,
                                                             retweetButtonContainerView,
                                                             likeButtonContainerView,
                                                             directMessageButtonContainerView])
        setupButtonStackView(buttonStackView)
        
        addButtons()
        
        setupButton(replyButton, inContainer: replyButtonContainerView)
        setupButton(retweetButton, inContainer: retweetButtonContainerView)
        setupButton(likeButton, inContainer: likeButtonContainerView)
        setupButton(directMessageButton, inContainer: directMessageButtonContainerView)
        
        addSubview(retweetCountLabel)
        addSubview(likeCountLabel)
        
        retweetCountLabel.anchor(topAnchor: retweetButton.topAnchor,
                                 topConstant: 0,
                                 leftAnchor: retweetButton.rightAnchor,
                                 leftConstant: 2,
                                 bottomAnchor: retweetButton.bottomAnchor,
                                 bottomConstant: 0,
                                 rightAnchor: nil,
                                 rightConstant: nil,
                                 widthConstant: nil,
                                 heightConstant: nil)
        
        likeCountLabel.anchor(topAnchor: likeButton.topAnchor,
                              topConstant: 0,
                              leftAnchor: likeButton.rightAnchor,
                              leftConstant: 2,
                              bottomAnchor: likeButton.bottomAnchor,
                              bottomConstant: 0,
                              rightAnchor: nil,
                              rightConstant: nil,
                              widthConstant: nil,
                              heightConstant: nil)
    }
    
    private func setupButtonStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(topAnchor: nil,
                         topConstant: nil,
                         leftAnchor: messageTextView.leftAnchor,
                         leftConstant: 0,
                         bottomAnchor: containerView.bottomAnchor,
                         bottomConstant: UI.smallOffset,
                         rightAnchor: UI.hasLongSide ? nil : containerView.rightAnchor,
                         rightConstant: UI.hasLongSide ? nil : 0,
                         widthConstant: UI.hasLongSide ? UI.TweetCell.buttonViewMaxWidth : nil,
                         heightConstant: UI.TweetCell.buttonSize.height)
    }
    
    private func addButtons() {
        addSubview(replyButton)
        addSubview(retweetButton)
        addSubview(likeButton)
        addSubview(directMessageButton)
    }
    
    private func setupButton(_ button: UIButton, inContainer container: UIView) {
        button.anchor(topAnchor: container.topAnchor,
                      topConstant: 0,
                      leftAnchor: container.leftAnchor,
                      leftConstant: 0,
                      bottomAnchor: nil,
                      bottomConstant: nil,
                      rightAnchor: nil,
                      rightConstant: nil,
                      widthConstant: UI.TweetCell.buttonSize.width,
                      heightConstant: UI.TweetCell.buttonSize.height)
    }
    
    // MARK: - utility funcs
    private func stringForNumber(number: Int) -> String {
        if number < 1_000 {
            return "\(number)"
        }
        else if number < 1_000_000 {
            let thousands = Int(number/1_000)
            return "\(thousands)K"
        }
        else {
            let millions = Int(number/1_000_000)
            return "\(millions)M"
        }
    }
    
    // MARK: - button actions
    @objc func replyButtonPressed() {
        delegate?.replyButtonPressed(cell: self)
    }
    
    @objc func retweetButtonPressed() {
        if !tweetInfo!.retweeted {
            delegate?.retweetButtonPressed(cell: self)
        }
        else {
            delegate?.unretweetButtonPressed(cell: self)
        }
    }
    
    @objc func likeButtonPressed() {
        if !tweetInfo!.favorited {
            delegate?.likeButtonPressed(cell: self)
            likeButton.isHighlighted = true
        }
        else {
            delegate?.unlikeButtonPressed(cell: self)
            likeButton.isHighlighted = false
        }
    }
    
    @objc func directMessageButtonPressed() {
        if !(tweetInfo?.user.following)! {
            return
        }
        delegate?.directMessageButtonPressed(cell: self)
    }
}
