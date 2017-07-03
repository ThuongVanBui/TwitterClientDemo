//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by HieuNT on 7/2/17.
//  Copyright © 2017 Lon. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets = [Tweet]()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

               // Do any additional setup after loading the view.
    }
    func loadData() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        
        
}
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.Logout()
        
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()

        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCell", for: indexPath) as! TweetsCell
        cell.tweetItem = tweets[indexPath.row]
      //  cell.delegate = self
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! TweetsCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let navigation = segue.destination as! UINavigationController
            let destVC = navigation.topViewController as! DetailViewController
            
            
            destVC.tweetItem = tweet
           // destVC.delegate = self
  
        }
    }

}
