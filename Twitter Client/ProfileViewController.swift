//
//  ProfileViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/28/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var follwersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = "\(tweet!.authorName!)"
        
        if let profileUrl = tweet?.authorProfile {
            profileImageView.setImageWithURL(profileUrl)
        }
        print(tweet)
        print(tweet?.text)
        follwersLabel.text = tweet?.numberOfFollowers as! String
        followingLabel.text = tweet?.numberOfFollowing as! String
        tweetsLabel.text = tweet?.numberOfTweets as! String
        taglineLabel.text = tweet?.tagline as! String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
