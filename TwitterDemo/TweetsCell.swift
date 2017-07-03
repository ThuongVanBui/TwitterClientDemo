//
//  TweetsCell.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/3/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit
protocol TweetCellDelegate {
    func onRetweet ()
    func onFavorite ()
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
            timeLabel.text = tweetItem?.createdAt
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
