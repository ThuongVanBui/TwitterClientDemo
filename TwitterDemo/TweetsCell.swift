//
//  TweetsCell.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/3/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit
protocol TweetCellDelegate {
    func onRetweet()
    func onLike()
}
class TweetsCell: UITableViewCell {

    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    
    @IBOutlet weak var retweetActionImage: UIButton!
    
    @IBOutlet weak var favoriteActionImage: UIButton!
    
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    var tweetId: String = ""
 var delegate: TweetCellDelegate!
    
    
    var tweetItem: Tweet? {
        didSet {
            
            favoriteCountLabel.text = self.tweetItem?.favoriteCount.description
            retweetCountLabel.text = self.tweetItem?.retweetCount.description
            tweetTextLabel.text = self.tweetItem?.text as String?
            userNameLabel.text = "@\(self.tweetItem!.user!.screenName!)"
            profileLabel.text = self.tweetItem?.user?.name
            tweetId = (tweetItem?.id_str)!
            
            if let retweet = tweetItem!.retweetBy {
                retweetLabel.text = "\(retweet) Retweeted"
                retweetImage.image = UIImage(named: "retweet_on")
            
            }
            else{
                retweetLabel.text = ""
                retweetImage.image = UIImage(named: "retweet_off")
            }

            
            let data = try! Data(contentsOf: (tweetItem?.user?.profileImageUrl! as! NSURL) as URL)
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
            timeLabel.text = tweetItem?.timeSinceCreated
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        retweetActionImage.setImage(UIImage(named: "retweet_off"), for: .normal)
        retweetActionImage.setImage(UIImage(named: "retweet_on"), for: .selected)
        favoriteActionImage.setImage(UIImage(named:"like_on"), for: .selected)
        favoriteActionImage.setImage(UIImage(named:"like_off"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onRetweet(_ sender: UIButton) {
        if retweetActionImage.isSelected {
            retweetActionImage.isSelected = false
        }else {
            retweetActionImage.isSelected = true
        }
        TwitterClient.sharedInstance?.retweetStatus(tweetId: tweetId, isRetweet: retweetActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onLike()
            
        })
        
       
    }
    @IBAction func onLike(_ sender: UIButton) {
        if favoriteActionImage.isSelected {
            favoriteActionImage.isSelected = false
        } else {
            favoriteActionImage.isSelected = true
        }
        
        TwitterClient.sharedInstance?.likeStatus(tweetId: tweetId, Like: favoriteActionImage.isSelected, completion: { (response, error) in
            
            self.delegate.onLike()
            
        })

    }

}
