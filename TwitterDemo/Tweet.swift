//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Lon on 6/30/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var retweetBy: String?
    var id_str: String?

    var text: String?
    var createdAt: String?
    
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var isRetweeted = false
    var isFavorited = false
    var retweet: Tweet?

    
    init(dictionary: NSDictionary) {
        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
            retweetBy = (dictionary.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
            
            
            
            text = retweetedStatus.value(forKey: "text") as! String?
            favoriteCount = (retweetedStatus.value(forKey: "favorite_count") as! Int?)!
            retweetCount = (retweetedStatus.value(forKey: "retweet_count") as! Int?)!
            id_str = retweetedStatus.value(forKey: "id_str") as! String?
            user = User(dictionnary: retweetedStatus.value(forKey: "user") as! NSDictionary)
            isRetweeted = true
        }else {
            id_str = dictionary["id_str"] as? String
            text = dictionary["text"] as! String?
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
            user = User(dictionnary: dictionary["user"] as! NSDictionary)
        }
        isFavorited = dictionary["favorited"] as! Bool
        isRetweeted = dictionary["retweeted"] as! Bool
        let dateString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        
        if let timestampString = dateString {
            let sinceDate = formatter.date(from: timestampString)
            formatter.dateFormat = "dd/MM/yyyy hh:mm"
            createdAt = formatter.string(from: sinceDate!)
        }


    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
