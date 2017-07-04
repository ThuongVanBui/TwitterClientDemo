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
    var profileImageUrl: URL?
    var tagLine: String?
    var dictionnary: NSDictionary?
    init(dictionnary: NSDictionary) {
        self.dictionnary = dictionnary
        name = dictionnary["name"] as? String
        screenName = dictionnary["screen_name"] as? String
        let profileUrlString = dictionnary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileImageUrl = URL(string: profileUrlString)
        }
        tagLine = dictionnary["description"] as? String
    }
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get{
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userdt = userData {
                if let dictionnay: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: userdt) as? NSDictionary{
                _currentUser = User(dictionnary: dictionnay)
                }
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
             let defaults = UserDefaults.standard
            if let user = user
            {
                let data: Data =  NSKeyedArchiver.archivedData(withRootObject: user.dictionnary!) as Data
                defaults.set(data, forKey: "currentUserData")

            }
            else{
                defaults.set(nil, forKey: "currentUserData")
            }
            user?.dictionnary
            defaults.set(user, forKey: "currentUser")
            defaults.synchronize()
           // print(currentUser!)
                    }
    }
    
    
}
