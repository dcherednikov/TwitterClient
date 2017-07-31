//
//  HomeVC.swift
//  TwitterClient
//
//  Created by Admin on 24/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


class HomeVC: UITableViewController, AppCoordinatorDelegate, NavigationBarResponder, TweetCellDelegate {
    public var composeRequestBlock: (() -> ())?
    public var replyRequestBlock: ((Tweet) -> ())?
    public var directMessageRequestBlock: ((User) -> ())?
    
    private let tweetCellId = "tweetCellId"
    private let noTweetsCellId = "noTweetsCellId"
    
    private var service = Service()
    private var dataSource = DataSource()
    
    private var shouldShowNoTweets = false
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let spinnerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UI.HomeVC.spinnerBackgroundColor
        view.layer.cornerRadius = UI.HomeVC.spinnerBackgroundCornerRadius
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return spinner
    }()
    
    // MARK: - UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBarItems()
        setupTableView()
        
        startSpinner()
        service.verifyCredentials(successBlock: {
            self.verificationSucceeded()
        }, errorBlock: { error in
            self.verificationFailed(error: error)
        })
    }
    
    // MARK: - initial setup
    private func setupViews() {
        tableView.addSubview(errorMessageLabel)
        tableView.addSubview(spinnerBackgroundView)
        tableView.addSubview(spinner)
        
        errorMessageLabel.center(inView: tableView)
        errorMessageLabel.widthAnchor.constraint(equalToConstant: UI.HomeVC.errorLabelWidth).isActive = true
        
        spinnerBackgroundView.center(inView: tableView)
        spinnerBackgroundView.heightAnchor.constraint(equalToConstant: UI.HomeVC.spinnerBackgroundSize.width).isActive = true
        spinnerBackgroundView.widthAnchor.constraint(equalToConstant: UI.HomeVC.spinnerBackgroundSize.height).isActive = true
        
        spinner.center(inView: tableView)
    }
    
    private func setupTableView() {
        tableView.register(TweetCell.self,
                           forCellReuseIdentifier: tweetCellId)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: noTweetsCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.twitterBackgroundGray
    }
    
    // MARK: - verification
    private func verificationSucceeded() {
        startSpinner()
        service.fetchHomeTimeline(successBlock: { statuses in
            self.stopSpinner()
            if statuses?.count == 0 {
                self.shouldShowNoTweets = true
            }
            else {
                self.dataSource.receiveTweetsData(statuses)
            }
            self.tableView.reloadData()
        }, errorBlock: { error in
            self.stopSpinner()
            self.showError("Fetching home timeline failed.", tryAgainCompletion: {
                self.verificationSucceeded()
            })
        })
    }
    
    private func verificationFailed(error: Error?) {
        stopSpinner()
        lockAppOnError("Something went wrong. Perhaps you didn't follow the instructions in the README file.")
    }
    
    // MARK: - spinner
    private func startSpinner() {
        spinner.startAnimating()
        spinnerBackgroundView.isHidden = false
    }
    
    private func stopSpinner() {
        spinner.stopAnimating()
        spinnerBackgroundView.isHidden = true
    }
    
    // MARK: - error handling
    private func lockAppOnError(_ error: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = error
        
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    private func showError(_ error: String, tryAgainCompletion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "try again", style: .default) { (action) in
            tryAgainCompletion()
        }
        
        alert.addAction(tryAgainAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowNoTweets ? 1 : dataSource.numberOfItems(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldShowNoTweets {
            return noTweetsCell(forIndexPath: indexPath)
        }
        
        return tweetCell(forIndexPath: indexPath)
    }
    
    private func noTweetsCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: noTweetsCellId,
                                                 for: indexPath)
        cell.textLabel?.text = "No tweets"
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    private func tweetCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellId,
                                                 for: indexPath) as! TweetCell
        let tweet = dataSource[indexPath] as! Tweet
        cell.tweetInfo = tweet
        service.loadImageForUser(tweet.user) { (image) in
            DispatchQueue.main.async {
                cell.profileImage = image
            }
        }
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shouldShowNoTweets {
            return UI.HomeVC.noTweetsCellHeigth
        }
        
        guard let tweet = dataSource[indexPath] as? Tweet else {
            return 0
        }
        let estimatedHeight = estimatedHeightForText(tweet.prettyPrint())
        return estimatedHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - height estimation
    private func estimatedHeightForText(_ text: NSAttributedString) -> CGFloat {
        let aporoximateTextViewWidth = UI.cellWidth - UI.HomeVC.widthPaddingForHeightEstimation
        let size = CGSize(width: aporoximateTextViewWidth, height: 1000) // arbitrary big number
        let estimatedFrame = text.boundingRect(with: size,
                                               options: .usesLineFragmentOrigin,
                                               context: nil)
        return estimatedFrame.height + UI.TweetCell.heightPadding
    }
        
    // MARK: - TweetCellDelegate
    func replyButtonPressed(cell: TweetCell) {
        guard let tweet = cell.tweetInfo else {
            return
        }
        replyRequestBlock?(tweet)
    }
    
    func retweetButtonPressed(cell: TweetCell) {
        guard let tweet = cell.tweetInfo else {
            return
        }
        dataSource.markTweetRetweeted(index: cell.tag, retweeted: true)
        tableView.reloadData()

        service.retweet(tweet, successBlock: { (status) in
            print("success")
        }) { (error) in
            self.showError("Failed to retweet.")
            self.dataSource.markTweetRetweeted(index: cell.tag, retweeted: false)
            self.tableView.reloadData()
        }
    }
    
    func unretweetButtonPressed(cell: TweetCell) {
        guard let tweet = cell.tweetInfo else {
            return
        }
        dataSource.markTweetRetweeted(index: cell.tag, retweeted: false)
        tableView.reloadData()
        
        service.unretweet(tweet, successBlock: { (status) in
            print("success")
        }) { (error) in
            self.showError("Failed to unretweet.")
            self.dataSource.markTweetRetweeted(index: cell.tag, retweeted: true)
            self.tableView.reloadData()
        }
    }
    
    func likeButtonPressed(cell: TweetCell) {
        guard let tweet = cell.tweetInfo else {
            return
        }
        dataSource.markTweetFavorited(index: cell.tag, favorited: true)
        tableView.reloadData()
        service.like(tweet: tweet, successBlock: { (status) in
            print("success")
        }, errorBlock: { (error) in
            self.showError("Failed to mark the tweet as favorite.")
            self.dataSource.markTweetFavorited(index: cell.tag, favorited: false)
            self.tableView.reloadData()
        })
    }
    
    func unlikeButtonPressed(cell: TweetCell) {
        guard let tweet = cell.tweetInfo else {
            return
        }
        dataSource.markTweetFavorited(index: cell.tag, favorited: false)
        tableView.reloadData()
        service.unlike(tweet: tweet, successBlock: { (status) in
            print("success")
        }, errorBlock: { (error) in
            self.showError("Failed to unmark the tweet as favorite.")
            self.dataSource.markTweetFavorited(index: cell.tag, favorited: true)
            self.tableView.reloadData()
        })
    }
    
    func directMessageButtonPressed(cell: TweetCell) {
        guard let user = cell.tweetInfo?.user else {
            return
        }
        directMessageRequestBlock?(user)
    }
    
    // MARK: - NavigationBarResponder
    func composeButtonPressed() {
        composeRequestBlock?()
    }
    
    // MARK: - AppCoordinatorDelegate
    func replyConfirmed(_ reply: String, toTweet tweet: Tweet) {
        service.reply(reply, toTweet: tweet, successBlock: { (status) in
            print("success")
        }) { (error) in
            self.showError("Failed to post reply to the tweet.")
        }
    }
    
    func newTweetConfirmed(_ text: String) {
        service.tweet(text, successBlock: { (status) in
            print("success")
            if status != nil {
                self.dataSource.insertNewTweets([status!])
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showError("Failed to post the tweet.")
        }
    }
    
    func directMessageConfirmed(_ message: String, toUser user: User) {
        service.sendMessage(message, toUser: user, successBlock: { (message) in
            print("success")
        }) { (error) in
            self.showError("Failed to send direct message.")
        }
    }
    
    // MARK: - 
    func newTweets() {
        let indexPath = IndexPath(row: 0, section: 0)
        let tweet = dataSource[indexPath] as! Tweet
        service.fetchHomeTimelineSinceTweet(tweet, successBlock: { (statuses) in
            self.dataSource.insertNewTweets(statuses)
            self.tableView.reloadData()
        }) { (error) in
            self.showError("Failed to fetch new tweets.")
        }
    }
}
