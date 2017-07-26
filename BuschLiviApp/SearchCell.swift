//
//  SearchCell.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/22/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SearchCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    func configureCell(Det: SearchDetail){
        self.name.text = Det.username
        let ref = Storage.storage().reference(forURL: Det.imgURL)
        ref.getData(maxSize: 1000000, completion: {(data,error) in
            if error == nil{
                self.img.image = UIImage(data: data!)
            }
        })

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
