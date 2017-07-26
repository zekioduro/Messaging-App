//
//  MessageCell.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/22/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var otherPersonView: UIView!
    @IBOutlet weak var youView: UIView!
    @IBOutlet weak var otherPerson: UILabel!
    @IBOutlet weak var you: UILabel!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configureCell(Det: Detail){
        if Det.sender == currentUser{
            youView.isHidden = false
            otherPersonView.isHidden = true
            you.text = Det.message
            otherPerson.text = ""
        } else {
            youView.isHidden = true
            otherPersonView.isHidden = false
            you.text = ""
            otherPerson.text = Det.message
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        you.numberOfLines = 0
        you.lineBreakMode = .byTruncatingTail
        you.minimumScaleFactor = 0.8
        otherPerson.numberOfLines = 0
        otherPerson.lineBreakMode = .byTruncatingTail
        otherPerson.minimumScaleFactor = 0.8
        youView.layer.cornerRadius = 8
        otherPersonView.layer.cornerRadius = 8
        youView.clipsToBounds = true
        otherPersonView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
