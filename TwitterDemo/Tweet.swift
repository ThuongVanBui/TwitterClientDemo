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
    var text: String?
    var createdAt: Date?
    
    var retweetCount = 0
    var favCount = 0
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionnary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        let createdAtString = dictionary["created_at"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int)!
        favCount = (dictionary["favorite_count"] as? Int)!
        
        
        if let createdAtString = createdAtString
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: createdAtString)
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
