//
//  TwitterClient.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/26/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstace = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "RTU1FQEe0pw9JKcaaQd58GOY6" , consumerSecret: "7qNnAsMVpewqbjD43m6almkNHvySbaKEo3eEnz9MmdhskvXPEr")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: ()->(), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstace.deauthorize()
        TwitterClient.sharedInstace.fetchRequestTokenWithPath("oauth/request_token", method: "Get", callbackURL: NSURL(string: "twitterDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            print("I got Token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        print("handling url ")
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.currentAccount({ (user: User) in
                
                User.currentUser = user
                print("saving user")
                self.loginSuccess?()
                
                }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            
        }) { (error: NSError!) in
            print("errror: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }

    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithrray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
                self.loginFailure?(error)
        })

    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        // GET the timeline
        GET("1.1/statuses/home_timeline.json", parameters: params,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // SUCCESS
                let tweets = Tweet.tweetsWithrray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
                //                for tweet in tweets! {
                //                    print("text: \(tweet.text!), created: \(tweet.createdAt!)")
                //                }
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                // FAILURE
                print("Unable to retrieve timeline: \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("It's in ")
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    
    func retweetTweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print("retweetTweet called")
        print(id)
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("retweet")
            completion(error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) in
                print("error retweeting \(error)")
                completion(error: error)
            }
        )}
    
    func unretweetTweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print("unretweetTweet called")
        print(id)
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("unretweet")
            completion(error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) in
                print("error retweeting \(error)")
                completion(error: error)
            }
        )}
    
    
    func favoriteTweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print("favoriteTweet called")
        print(id)
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("favorite")
            completion(error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) in
                print(error.localizedDescription)
                completion(error: error)
            }
        )}
    
    func unfavoriteTweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        print("unfavoriteTweet called")
        print(id)
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("unfavorite")
            completion(error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) in
                print(error.localizedDescription)
                completion(error: error)
            }
        )}

    
    func postTweet(params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("posted tweet")
            completion(error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error tweeting")
                print(error.localizedDescription)
                completion(error: error)
            }
        )}
}
