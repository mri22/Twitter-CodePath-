//
//  UserProfileViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/28/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import PeekPop
import DGElasticPullToRefresh



class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PeekPopPreviewingDelegate {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTaglineLabel: UILabel!
    @IBOutlet weak var numberOfTweets: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    var peekPop: PeekPop?
    
    var userCell: UserCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        userNameLabel.text = "\(User.currentUser!.name!)"
        
        if let profileUrl = User.currentUser?.profileUrl {
            profileImageView.setImageWithURL(profileUrl)
        }
        numberOfFollowersLabel.text = User.currentUser?.numberOfFollowers as! String
        numberOfTweets.text = User.currentUser?.numberOfTweets as! String
        numberOfFollowingLabel.text = User.currentUser?.numberOfFollowing as! String
        userTaglineLabel.text = User.currentUser?.tagline as! String
        print(userTaglineLabel.text)
        if let backgroundUrl = User.currentUser?.backgroundPictureUrl {
            backgroundImageView.setImageWithURL(backgroundUrl)
        }
        
        loadData()
        ///////////////////////
        
        peekPop = PeekPop(viewController: self)
        peekPop?.registerForPreviewingWithDelegate(self, sourceView: self.view)
        
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self!.loadData()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        

    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    func previewingContext(previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        return self
    }
    
    func previewingContext(previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
        
        
        let tweet = self.tweets[indexPath.row]
        //cell.deleteDelegate = self
        
        cell.tweet = tweet
        
        
        if let profileURL = tweet.authorProfile {
            cell.userProfieImageView.setImageWithURL(profileURL)
            
        }
        cell.userNameLabel.text = tweet.authorName as? String
        cell.userTweetTextView.text = tweet.text as? String
        
        
        return cell
        
    }
    
    func loadData() {
        
        TwitterClient.sharedInstace.userTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            self.tableView.dg_stopLoading()
            self.tableView.reloadData()
            //            for tweet in tweets {
            //                print(tweet.text)
            //            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
    }
    
//    func deleteCell(userCell: UserCell) {
//        self.userCell = userCell
//        TwitterClient.sharedInstace.postTweetReply(replyStatusID: (userCell.tweet!.id_str)!, success: { (tweet: Tweet) in
//            
//        }) { (error: NSError) in
//        print(error.localizedDescription)
//    }
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension UIScrollView {
//    func dg_stopScrollingAnimation() {}
//}
