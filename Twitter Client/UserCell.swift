//
//  UserCell.swift
//  Twitter Client
//
//  Created by Mazen Raafat Ibrahim on 6/29/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    //weak var deleteDelegate: UserCellDeleteDelegate?

    @IBOutlet weak var userProfieImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTweetTextView: UITextView!
    
    var tweet: Tweet?
    
    
//    @IBAction func deleteAction(sender: AnyObject) {
//        deleteDelegate?.deleteCell(self)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//protocol UserCellDeleteDelegate : class {
//    func deleteCell(userCell: UserCell)
//}

