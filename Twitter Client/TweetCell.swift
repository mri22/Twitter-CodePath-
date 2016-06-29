//
//  TweetCell.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/27/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
    
    weak var retweetDelegate: TweetCellRetweetDelegate?
    weak var favoriteDelegate: TweetCellFavoriteDelegate?
    weak var profileDelegate: TweetCellProfileDelegate?
    weak var replyDelegate: TweetCellReplyDelegate?
    
    
    @IBOutlet weak var tweetLabel: UITextView!
    @IBOutlet weak var authorProfileImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var retweeted: Bool?
    var favorited: Bool?
    
    var tweet: Tweet!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        favoriteDelegate?.favorite(self)
    }

    @IBAction func retweetAction(sender: AnyObject) {
        retweetDelegate?.retweet(self)
    }
    
    @IBAction func onProfilePictutreButton(sender: AnyObject) {
        profileDelegate?.profileCell(self)
    }
    @IBAction func onReplyButton(sender: AnyObject) {
        replyDelegate?.reply(self)
    }
}

protocol TweetCellRetweetDelegate : class {
    func retweet(tweetCell: TweetCell)
}

protocol TweetCellFavoriteDelegate : class {
    func favorite(tweetCell: TweetCell)
}

protocol TweetCellProfileDelegate : class {
    func profileCell(tweetCell: TweetCell)
}

protocol TweetCellReplyDelegate : class {
    func reply(tweetCell: TweetCell)
}