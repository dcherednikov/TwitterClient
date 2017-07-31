//
//  ComposeVC.swift
//  TwitterClient
//
//  Created by Admin on 26/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

fileprivate let maxCharacters = 140

class ComposeVC: UIViewController, UITextViewDelegate {
    public var completion: ((String?, Bool) -> ())?
    public var shouldLimitCharacters = true
    
    private var confirmed = false
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UI.textFont
        return textView
    }()

    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UI.ComposeVC.characterCountLabelTextColor
        label.backgroundColor = .white
        label.font = UI.textFont
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        
        textView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        completion?(textView.text, confirmed)
        completion = nil
    }
    
    // MARK: - inital setup
    private func setupViews() {
        view.addSubview(characterCountLabel)
        view.addSubview(textView)
        
        let heightConstant: CGFloat = shouldLimitCharacters ? UI.ComposeVC.characterCountLabelHeight : 0
        characterCountLabel.anchor(topAnchor: view.topAnchor,
                                   topConstant: 0,
                                   leftAnchor: view.leftAnchor,
                                   leftConstant: 0,
                                   bottomAnchor: nil,
                                   bottomConstant: nil,
                                   rightAnchor: view.rightAnchor,
                                   rightConstant: nil,
                                   widthConstant: nil,
                                   heightConstant: heightConstant)
        
        textView.anchor(topAnchor: characterCountLabel.bottomAnchor,
                        topConstant: 0,
                        leftAnchor: view.leftAnchor,
                        leftConstant: 0,
                        bottomAnchor: view.bottomAnchor,
                        bottomConstant: 0,
                        rightAnchor: view.rightAnchor,
                        rightConstant: 0,
                        widthConstant: nil,
                        heightConstant: nil)
        
        characterCountLabel.isHidden = !shouldLimitCharacters
        characterCountLabel.text = stringForCounter()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonPressed))
    }
    
    // MARK: - button actions
    @objc private func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonPressed() {
        confirmed = true
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = stringForCounter()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !shouldLimitCharacters {
            return true
        }
        let textLenghtAfterReplacement = textView.text.characters.count - range.length + text.characters.count
        if  textLenghtAfterReplacement > maxCharacters {
            return false
        }
        return true
    }
    
    private func stringForCounter() -> String {
        let count = maxCharacters - textView.text.characters.count
        return "\(count)/\(maxCharacters)"
    }
}
