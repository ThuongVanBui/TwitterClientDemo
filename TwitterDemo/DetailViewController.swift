//
//  DetailViewController.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/3/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    
    
    @IBOutlet weak var retweetActionImage: UIButton!
    
    @IBOutlet weak var favoriteActionImage: UIButton!
    
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    var tweetId = ""
    var delegate: TweetCellDelegate!
    
    var tweetItem: Tweet!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        retweetActionImage.setImage(UIImage(named: "retweet_off"), for: .normal)
//        retweetActionImage.setImage(UIImage(named: "retweet_on"), for: .selected)
//        favoriteActionImage.setImage(UIImage(named:"like_off"), for: .selected)
//        favoriteActionImage.setImage(UIImage(named:"like_on"), for: .normal)
        favoriteCountLabel.text = tweetItem?.favoriteCount.description
        retweetCountLabel.text = tweetItem?.retweetCount.description
        tweetTextLabel.text = tweetItem?.text as String?
        userNameLabel.text = "@\(tweetItem!.user!.screenName!)"
        profileLabel.text = tweetItem?.user?.name
        tweetId = (tweetItem?.id_str)!
        
        if let retweet = tweetItem!.retweetBy {
            retweetLabel.text = "\(retweet) Retweeted"
            retweetImage.image = UIImage(named: "retweet_on")
               }
        
        let data = try! Data(contentsOf: tweetItem?.user?.profileImageUrl as! URL)
        profileImage.image = UIImage(data: data)
        
        if (tweetItem?.isFavorited)! {
            favoriteActionImage.isSelected = true
        }else {
            favoriteActionImage.isSelected = false
        }
        
        if(tweetItem?.isRetweeted)! {
            retweetActionImage.isSelected = true
        }else {
            retweetActionImage.isSelected = false
        }
        timeLabel.text = tweetItem?.createdAt

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancle(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
   

}
