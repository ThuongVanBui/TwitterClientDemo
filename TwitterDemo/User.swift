//
//  User.swift
//  TwitterDemo
//
//  Created by Lon on 6/30/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagLine: String?
    var dictionnary: NSDictionary?
    init(dictionnary: NSDictionary) {
        self.dictionnary = dictionnary
        name = dictionnary["name"] as? String
        screenName = dictionnary["screen_name"] as? String
        let profileUrlString = dictionnary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = URL(string: profileUrlString)
        }
        tagLine = dictionnary["description"] as? String
    }
    static let defaults = UserDefaults.standard
    static var _currentUser: User?
    
    class var currentUser: User? {
        get{
            
            if _currentUser == nil {
               //  let defaults = UserDefaults.standard
                let userData = defaults.data(forKey: "currentUserData")
            if let userData = userData {
                let dictionnay = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data) as! NSDictionary
                _currentUser = User(dictionnary: dictionnay)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
           // let defaults = UserDefaults.standard
            if let user = user
            {
                let data = NSKeyedArchiver.archivedData(withRootObject: user)
                defaults.set(data, forKey: "currentUserData")
                defaults.synchronize()

            }
            else{
                defaults.set(nil, forKey: "currentUserData")
            }
                    }
    }
    
    
}
