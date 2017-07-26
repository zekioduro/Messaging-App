//
//  Chat.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/8/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Chat: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recips: [MessageDetails] = [MessageDetails]()
    var Ref: String!
    var recipientID: String!
    var recipientName: String!
    
    var currentUser: String! = KeychainWrapper.standard.string(forKey: "uid")
    
    @IBOutlet weak var table: UITableView!
 
  

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Det = self.recips[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recip") as? MessageDetailCell {
            cell.configureCell(messageDet: Det)
            return cell
        } else {
            return MessageDetailCell()
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        try! Auth.auth().signOut()
        KeychainWrapper.standard.removeObject(forKey: "uid")
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipientName = self.recips[indexPath.row].recipientName
        self.recipientID = self.recips[indexPath.row].recipientID
        self.Ref = self.recips[indexPath.row].Ref
        table.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "toMessages", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessages"{
            if let dest = segue.destination as? Messages{
                    dest.Ref = self.Ref
                    dest.recipientID = self.recipientID
                    dest.recipientName = self.recipientName
                    dest.messageID = self.Ref
            }
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {(snapshot) in
            self.recips.removeAll()
            let users = snapshot.children.allObjects as! [DataSnapshot]
            for data in users{
                
                if let info = data.value as? Dictionary<String,AnyObject>{
                    
                    let Det: MessageDetails = MessageDetails()
                    Det.recipientID = info["recipientID"] as! String
                    Det.recipientName = info["recipientName"] as! String
                    Det.imgURL = info["recipientImg"] as! String
                    Det.Ref = info["Ref"] as! String
                    Database.database().reference().child("messages").child(Det.Ref).observe(.value, with: {(snapshot) in
                        
                        let items = snapshot.children.allObjects as! [DataSnapshot]
                        let prev = items[items.count-1]
                        if let data = prev.value as? Dictionary<String,AnyObject>{
                            Det.prev = data["message"] as! String
                            self.recips.append(Det)
                            self.table.reloadData()
                        }
                    })
                }
                
            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        /*Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {(snapshot) in
            self.recips.removeAll()
            let users = snapshot.children.allObjects as! [DataSnapshot]
            for data in users{
                
                if let info = data.value as? Dictionary<String,AnyObject>{
                
                    let Det: MessageDetails = MessageDetails()
                    Det.recipientID = info["recipientID"] as! String
                    Det.recipientName = info["recipientName"] as! String
                    Det.imgURL = info["recipientImg"] as! String
                    Det.Ref = info["Ref"] as! String
                    Database.database().reference().child("messages").child(Det.Ref).observe(.value, with: {(snapshot) in
                        
                        let items = snapshot.children.allObjects as! [DataSnapshot]
                        let prev = items[items.count-1]
                        if let data = prev.value as? Dictionary<String,AnyObject>{
                            Det.prev = data["message"] as! String
                            self.recips.append(Det)
                            self.table.reloadData()
                        }
                    })
                }

            }
        })*/
       
    }



}
