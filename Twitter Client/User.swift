//
//  User.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/26/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class User: NSObject {

    static let userDidLogoutNotification = "userDidLogout"

    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var numberOfTweets: NSString?
    var numberOfFollowers: NSString?
    var numberOfFollowing: NSString?
    var backgroundPictureUrl: NSURL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
        
        self.numberOfFollowers = "\(dictionary["followers_count"]!)"
        self.numberOfFollowing = "\(dictionary["friends_count"]!)"
        self.numberOfTweets = "\(dictionary["statuses_count"]!)"
        
        if let profileUrlString = dictionary["profile_banner_url"] as? String {
            self.backgroundPictureUrl = NSURL(string: profileUrlString)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            print("current user saved")
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                    defaults.setObject(data, forKey: "currentUserData")
                
            } else {
            
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
