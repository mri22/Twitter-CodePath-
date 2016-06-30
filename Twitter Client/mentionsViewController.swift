////
////  mentionsViewController.swift
////  Twitter Client
////
////  Created by Mazen Raafat Ibrahim on 6/30/16.
////  Copyright © 2016 Mazen. All rights reserved.
////
//
//import UIKit
//
//class mentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var tweets: [Tweet]!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        userNameLabel.text = "\(User.currentUser!.name!)"
//        
//        if let profileUrl = User.currentUser?.profileUrl {
//            profileImageView.setImageWithURL(profileUrl)
//        }
//        numberOfFollowersLabel.text = User.currentUser?.numberOfFollowers as! String
//        numberOfTweets.text = User.currentUser?.numberOfTweets as! String
//        numberOfFollowingLabel.text = User.currentUser?.numberOfFollowing as! String
//        userTaglineLabel.text = User.currentUser?.tagline as! String
//        
//        loadData()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if let tweets = self.tweets {
//            return tweets.count
//        } else {
//            return 0
//        }
//        
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
//        
//        
//        let tweet = self.tweets[indexPath.row]
//        
//        
//        if let profileURL = tweet.authorProfile {
//            cell.userProfieImageView.setImageWithURL(profileURL)
//            
//        }
//        cell.userNameLabel.text = tweet.authorName as? String
//        cell.userTweetTextView.text = tweet.text as? String
//        
//        
//        return cell
//        
//    }
//    
//    func loadData() {
//        
//        TwitterClient.sharedInstace.userTimeline({ (tweets: [Tweet]) in
//            self.tweets = tweets
//            
//            
//            self.tableView.reloadData()
//            //            for tweet in tweets {
//            //                print(tweet.text)
//            //            }
//        }) { (error: NSError) in
//            print(error.localizedDescription)
//        }
//        
//    }
//
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
