//
//  Messages.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/20/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class Messages: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var Ref: String!
    var recipientID: String!
    var recipientName: String!
    var recipientImg: String!
    var messages = [Detail]()
    var temp = Detail()
    var messageID: String!

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Det = messages[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "message") as? MessageCell{
            cell.configureCell(Det: Det)
            return cell
            
        } else {
            return MessageCell()
        }
    }
    
    @IBAction func send(_ sender: AnyObject) {
        let message = ["message": self.textField.text,"sender": self.currentUser]
        if messageID == nil || messageID == "" {
            let ref = Database.database().reference().child("messages").childByAutoId().key
            self.Ref = ref
            Database.database().reference().child("messages").child(ref).childByAutoId().setValue(message)
            let info: Dictionary<String, AnyObject> = ["recipientID": self.recipientID as AnyObject, "recipientName": self.recipientName as AnyObject, "recipientImg": self.recipientImg as AnyObject, "Ref": ref as AnyObject]
            Database.database().reference().child("users").child(currentUser!).child("messages").childByAutoId().setValue(info)
            print("hi")
            Database.database().reference().child("users").child(currentUser!).child("info").observe(.value, with: {(snapshot) in
                if let dict = snapshot.value as? Dictionary<String, AnyObject>{
                    let img = dict["userImg"] as! String
                    let name = dict["username"] as! String
                    let info2 = ["recipientID": self.currentUser!, "recipientName": name, "recipientImg": img, "Ref": ref] as [String : Any]
                    Database.database().reference().child("users").child(self.recipientID).child("messages").childByAutoId().setValue(info2)

                }
            })
        } else {
          Database.database().reference().child("messages").child(messageID).childByAutoId().setValue(message)
          
        }
        let Det = Detail()
        Det.message = self.textField.text
        Det.sender = self.currentUser
        self.messages.append(Det)
        self.textField.text = ""
        table.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){
            if self.messages.count > 0{
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.table.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 300
        
        label.text = recipientName
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){
            if self.messages.count > 0{
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.table.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        print(messageID)
        if messageID != nil && messageID != ""{
            Database.database().reference().child("messages").child(messageID).observe(.value, with: {(snapshot) in
                
                    let messes = snapshot.children.allObjects as! [DataSnapshot]
                    self.messages.removeAll()
                for data in messes{
                    Database.database().reference().child("messages").child(self.messageID).child(data.key).observe(.value, with: {(snapshot) in
                        if let mess = snapshot.value as? Dictionary<String, AnyObject>{
                            let Det = Detail()
                            Det.message = mess["message"] as! String
                            Det.sender = mess["sender"] as! String
                            self.messages.append(Det)
                            self.table.reloadData()
                        }
                    })
                }
            })
            
        }
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with: {(snapshot) in
            let explore = snapshot.children.allObjects as! [DataSnapshot]
            for data in explore{
                Database.database().reference().child("users").child(self.currentUser!).child("messages").child(data.key).observe(.value, with: {(snapshot) in
                    if let info = snapshot.value as? Dictionary<String, String>{
                        if info["recipientID"] == self.recipientID{
                            if let ID = info["Ref"]{
                                self.messageID = ID
                            }
                        }
                    }
                })
            }
        })
        // Do any additional setup after loading the view.
    }
    func keyboardWillShow(notify: NSNotification){
        if let size = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= size.height
            }
        }
    }
    
    func keyboardWillHide(notify: NSNotification){
        if let size = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += size.height
            }
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

 
}
