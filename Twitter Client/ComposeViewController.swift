//
//  ComposeViewController.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/28/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var currentUser: User?
    
    var replyTo: String?
    
    var tweet: Tweet?

    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var handleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        
        if let tweet = tweet {
            tweetTextView.text = "@" + (tweet.screenname! as String) + " "
        }
//        if replyTo != nil{
//            tweetTextView.text = "\(replyTo!)"
//        }
        
        //tweetTextView.font.c

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onComposeButton(sender: AnyObject) {
        var params = NSDictionary()
        params = ["status" : tweetTextView.text!]
        print(params)
        TwitterClient.sharedInstace.postTweet(params, completion: {(error) -> () in
        })
        
    self.performSegueWithIdentifier("composeSegue", sender: composeButton)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let checkString = "\n"
        var crCount = countOccurrences(tweetTextView.text, forSubstring: checkString) + countOccurrences(text, forSubstring: checkString)
        if(crCount > 4)
        {
            return false
        }
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        countLabel.text = "\(141 - newLength)"
        return newLength <= 140
    }
    
    func countOccurrences(toCheck: String, forSubstring: String) -> Int
    {
        var tokenArray = toCheck.componentsSeparatedByString(forSubstring)
        return tokenArray.count-1
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
