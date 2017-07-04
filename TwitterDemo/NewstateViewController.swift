//
//  NewstateViewController.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/3/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit

class NewstateViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var newTweetTextField: UITextView!
    
    @IBOutlet weak var tweetButton: UIButton!
    var tweetItem : Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        newTweetTextField.delegate = self
        let user = User.currentUser
        if user != nil{
            profileImage.setImageWith((user?.profileImageUrl)!)
            profileLabel.text = user?.name
            usernameLabel.text = "@\(user?.screenName)"
        }
           //    let data = try! Data(contentsOf: (tweetItem?.user?.profileImageUrl as! NSURL) as! URL)
        //profileImage.image = UIImage(data: data)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onPost(_ sender: UIButton) {
        TwitterClient.sharedInstance?.updateStatus(status: newTweetTextField.text, completion: { (results, error) in
            if (results != nil) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    func textViewDidChange(_ textView: UITextView) {
        if newTweetTextField.text == "" {
            tweetButton.isEnabled = false
        } else {
            tweetButton.isEnabled = true
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newTweetTextField.text.contains("How are you today?") {
            newTweetTextField.text = ""
            tweetButton.isEnabled = false
        }
    }
}
