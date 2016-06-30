//
//  Tweet.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/26/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import PrettyTimestamp

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeted: Bool?
    var favorited: Bool?
    
    
    var numberOfFollowers: NSString?
    var numberOfFollowing: NSString?
    var tagline: NSString?
    var numberOfTweets: NSString?
    var profileImageUrl: NSURL?
    var screenname: NSString?
    
    
    var authorDictionary: NSDictionary?
    var authorName: NSString?
    var authorProfile: NSURL?
    var authorBackgroundPicture: NSURL?
    
    var id: Int?
    var id_str : String?
    
    init(dictionary: NSDictionary) {
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool ?? false
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool ?? false
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMMd HH:mm:ss Z y"
            let NSDateStamp = formatter.dateFromString(timestampString)
            let timeString = NSDateStamp?.prettyTimestampSinceNow()
            timestamp = timeString
        }
        
        id = dictionary["id"] as? Int
        id_str = dictionary["id_str"] as? String
        
        self.authorDictionary = dictionary["user"] as? NSDictionary
        
        self.authorName = authorDictionary!["name"] as? String
       if let profileUrlString = authorDictionary!["profile_image_url"] as? String {
            self.authorProfile = NSURL(string: profileUrlString)
        }
        
        self.numberOfFollowers = "\(authorDictionary!["followers_count"]!)"
        self.numberOfFollowing = "\(authorDictionary!["friends_count"]!)"
        
        self.tagline = "\(authorDictionary!["description"]!)"
        self.numberOfTweets = "\(authorDictionary!["statuses_count"]!)"
        self.screenname = "\(authorDictionary!["screen_name"]!)"
        
        if let profileUrlString = authorDictionary!["profile_banner_url"] as? String {
            self.authorBackgroundPicture = NSURL(string: profileUrlString)
        }
        
        
    }
    
    class func tweetsWithrray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }

}
