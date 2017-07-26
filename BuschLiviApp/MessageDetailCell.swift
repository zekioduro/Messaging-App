//
//  MessageDetailCell.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/9/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MessageDetailCell: UITableViewCell {
    
   
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var preview: UILabel!
    
    
    
    
    
    func configureCell(messageDet: MessageDetails){
        let ref = Storage.storage().reference(forURL: messageDet.imgURL)
        ref.getData(maxSize: 1000000, completion: {(data,error) in
            if error == nil{
                self.img.image = UIImage(data: data!)
            }
        })
        username.text = messageDet.recipientName
        preview.text = messageDet.prev
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
