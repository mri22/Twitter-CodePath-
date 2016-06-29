//
//  tweetDetailViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/28/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var authorProfileImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.retweetCountLabel.text = "\(tweet.retweetCount)"
        self.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
        if let profileURL = self.tweet.authorProfile {
            authorProfileImage.setImageWithURL(profileURL)
            
        }
        tweetLabel.text = self.tweet.text as? String
        authorNameLabel.text = self.tweet.authorName as? String
        timestampLabel.text = self.tweet.timestamp

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstace.retweetTweet(tweet.id_str!, params: nil, completion:  { (error) -> () in
            print(self.tweet.id_str)
            //tweetCell.retweetButton.imageView?.image = UIImage(named: "iconmonstr-retweet-1-32.png")
            let thisTweet = self.tweet! as Tweet
            if thisTweet.retweetCount > 0 {
                self.retweetCountLabel.text = "\(thisTweet.retweetCount + 1)"
                
            } else {
                self.retweetCountLabel.text = "1"
            }
        })
        
    }

    @IBAction func onFavoriteButton(sender: AnyObject) {
        TwitterClient.sharedInstace.favoriteTweet(tweet!.id_str!, params: nil, completion: {(error) -> () in
            //tweetCell.favoriteButton.imageView?.image = UIImage(named: "favorite_on.png")
            let thisTweet = self.tweet! as Tweet
            if thisTweet.favoritesCount > 0 {
                self.favoriteCountLabel.text = "\(thisTweet.favoritesCount + 1)"
            } else {
                self.favoriteCountLabel.text = "1"
            }
        })

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
