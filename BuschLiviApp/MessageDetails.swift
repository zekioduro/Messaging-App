//
//  MessageDetails.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/16/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class MessageDetails{
    var recipientID: String!
    var recipientName: String!
    var imgURL: String!
    var Ref: String!
    var prev: String!
    
    init(_recID:String,_recName:String,_imgURL:String, _Ref: String){
        recipientID = _recID
        recipientName = _recName
        imgURL = _imgURL
        Ref = _Ref
    }
    
    init() {
        
    }
}
