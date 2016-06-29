//
//  TweetsViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/26/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellRetweetDelegate, TweetCellFavoriteDelegate, TweetCellProfileDelegate, TweetCellReplyDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var loadingAdditionalTweets = false
    
    var tweets: [Tweet]!
    
    var profileCell: TweetCell?
    var replyCell: TweetCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadData()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstace.logout()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        
        cell.retweetDelegate = self
        cell.favoriteDelegate = self
        cell.profileDelegate = self
        cell.replyDelegate = self
        
        let tweet = self.tweets[indexPath.row]
        
        cell.tweetLabel.text = tweet.text as? String
        cell.screenNameLabel.text = "@\(tweet.screenname!)"
        cell.tweet = tweet
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoriteCount.text = "\(tweet.favoritesCount)"
        
        if tweet.favorited! {
            cell.favoriteButton.imageView?.image = UIImage(named: "favorite_on.png")
        } else {
            cell.favoriteButton.imageView?.image = UIImage(named: "favorite.png")
        }
        
        if tweet.favoritesCount > 0 {
            cell.favoriteCount.text = "\(tweet.favoritesCount)"
        } else {
            cell.favoriteCount.text = ""
        }

        if tweet.retweeted! {
            cell.retweetButton.imageView?.image = UIImage(named: "retweet_on.png")
        } else {
            cell.retweetButton.imageView?.image = UIImage(named: "retweet.png")
        }
        if tweet.retweetCount > 0 {
            cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        } else {
            cell.retweetCountLabel.text = ""
        }
        
        if let profileURL = tweet.authorProfile {
            cell.authorProfileImage.setImageWithURL(profileURL)

        }
        cell.authorNameLabel.text = tweet.authorName as? String
        cell.timestampLabel.text = tweet.timestamp
        
        
        return cell
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        TwitterClient.sharedInstace.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            refreshControl.endRefreshing()
            //            for tweet in tweets {
            //                print(tweet.text)
            //            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }

    }
    
    func loadData() {
        
        TwitterClient.sharedInstace.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            
            self.tableView.reloadData()
            //            for tweet in tweets {
            //                print(tweet.text)
            //            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }

    }
    
    func retweet(tweetCell: TweetCell) {
        if !tweetCell.tweet.retweeted! {
            TwitterClient.sharedInstace.retweetTweet(tweetCell.tweet.id_str!, params: nil, completion:  { (error) -> () in
                print(tweetCell.tweet.id_str)
                tweetCell.retweetButton.imageView?.image = UIImage(named: "retweet_on.png")
                let thisTweet = tweetCell.tweet! as Tweet
                thisTweet.retweeted = true
                
                if thisTweet.retweetCount > 0 {
                    tweetCell.retweetCountLabel.text = "\(thisTweet.retweetCount + 1)"
                
                } else {
                    tweetCell.retweetCountLabel.text = "1"
                }
            })
        } else {
            
            
            TwitterClient.sharedInstace.unretweetTweet(tweetCell.tweet.id_str!, params: nil, completion:  { (error) -> () in
                print(tweetCell.tweet.id_str)
                tweetCell.retweetButton.imageView?.image = UIImage(named: "retweet.png")
                let thisTweet = tweetCell.tweet! as Tweet
                thisTweet.retweeted = false
                tweetCell.retweetCountLabel.text = "\(thisTweet.retweetCount)"
                
            })
        }
    }
    
    func favorite(tweetCell: TweetCell) {
        if !tweetCell.tweet.favorited! {
            TwitterClient.sharedInstace.favoriteTweet(tweetCell.tweet!.id_str!, params: nil, completion: {(error) -> () in
                tweetCell.favoriteButton.imageView?.image = UIImage(named: "favorite_on.png")
                let thisTweet = tweetCell.tweet! as Tweet
                thisTweet.favorited = true
                
                if thisTweet.favoritesCount > 0 {
                    tweetCell.favoriteCount.text = "\(thisTweet.favoritesCount + 1)"
                    print(thisTweet.favorited)
                } else {
                    tweetCell.favoriteCount.text = "1"
                }
            })
        } else {
            TwitterClient.sharedInstace.unfavoriteTweet(tweetCell.tweet!.id_str!, params: nil, completion: {(error) -> () in
                tweetCell.favoriteButton.imageView?.image = UIImage(named: "favorite.png")
                let thisTweet = tweetCell.tweet! as Tweet
                thisTweet.favorited = false
                tweetCell.favoriteCount.text = "\(thisTweet.favoritesCount)"
                print(thisTweet.favorited)
            })

        }
    }
    
    func profileCell(tweetCell: TweetCell) {
        self.profileCell = tweetCell
    }
    
    func reply(tweetCell: TweetCell) {
        self.replyCell = tweetCell
        //let replyTo = tweetCell.screenNameLabel!.text as String?
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                
                
                loadAdditionalTweets()
            }
        }
    }
    
    func fetchTweets(params: NSDictionary?) {
        
        TwitterClient.sharedInstace.homeTimelineWithParams(params) { (tweets, error) -> () in
            self.isMoreDataLoading = false
            self.tweets = tweets
            self.tableView.reloadData()
//            if self.refreshControl.refreshing {
//                self.refreshControl.endRefreshing()
//            }
        }

        
    }
    
    func loadAdditionalTweets() {
        if let max_id = tweets?.last?.id {
            let max_id_string = String(max_id)
            let params = ["max_id": max_id_string]
            fetchTweets(params)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        }
        
        if segue.identifier == "profileSegue" {
            let indexPath = tableView.indexPathForCell(profileCell!)
            let tweet = tweets[(indexPath?.row)!]
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            
            profileViewController.tweet = tweet
        }
        if segue.identifier == "replySegue" {
            let indexPath = tableView.indexPathForCell(replyCell!)
            let tweet = tweets[(indexPath?.row)!]
            
            let composeViewController = segue.destinationViewController as! ComposeViewController
            
            composeViewController.tweet = tweet
        }
        
        
    }
    

}

