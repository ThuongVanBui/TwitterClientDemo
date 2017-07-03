//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/1/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import Foundation

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL:NSURL(string:"https://api.twitter.com/")! as URL!, consumerKey: "O2xgw3OdWH2VJLGE39ozM1Cjw", consumerSecret: "YvqT3rq5v8TFngNihIcjikzs8y33sOfsurYSwV4YDVSRQGhGU2")
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "myTwitterDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a token!")
            print(requestToken.token)
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
            UIApplication.shared.openURL(url! as URL)
        }, failure: { (error: Error!) in
            print("error:\(error.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

    }
    func Logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("I got access Token!")
            self.currentAccount(success: { (user: User) in
               //               // print(user)
                self.loginSuccess?()
                //User.currentUser = user

            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })

    }
    func currentAccount(success: @escaping (User) -> (),failure: @escaping (NSError) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("account: \(response)")
            let userDictionnary = response as! NSDictionary
            let user = User(dictionnary: userDictionnary)
           success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error:\(error)")
            failure(error as NSError)
        })
        
    }
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure:@escaping (NSError) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
          success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: NSError) in
            print("error:\(error)")
            failure(error)
        } as? (URLSessionDataTask?, Error) -> Void)
    }
    func updateStatus(status: String, completion: @escaping (_ response: Any?, _ error: NSError?) -> () ) {
        var params = [String : String]()
        params["status"] = status
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any ) in
            print("update status success!")
            completion(response, nil)
        }, failure: { (task: URLSessionDataTask?, error) in
            completion(nil, error as NSError?)
            print("update status fail!")
        })
}
    func likeStatus(tweetId: String, Like: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if Like {
            post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Like!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Like error!")
            }
        }else {
            post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Unlike !")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Unlike error!")
            })
        }
        
    }
    func retweetStatus(tweetId: String, isRetweet: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if isRetweet {
            post("1.1/statuses/retweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Retweeded!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Retweeded error")
            }
        }else {
            post("1.1/statuses/unretweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Detroy Unretweed!")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Detroy Unretweed error")
            })
        }
    }
}
