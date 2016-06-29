//
//  UserProfileViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/28/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTaglineLabel: UILabel!
    @IBOutlet weak var numberOfTweets: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userNameLabel.text = "\(User.currentUser!.name!)"
        
        if let profileUrl = User.currentUser?.profileUrl {
            profileImageView.setImageWithURL(profileUrl)
        }
        numberOfFollowersLabel.text = User.currentUser?.numberOfFollowers as! String
        numberOfTweets.text = User.currentUser?.numberOfTweets as! String
        numberOfFollowingLabel.text = User.currentUser?.numberOfFollowing as! String
        userTaglineLabel.text = User.currentUser?.tagline as! String

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
