//
//  Search.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/22/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SwiftKeychainWrapper
class Search: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    var results = [SearchDetail]()
    var filteredResults = [SearchDetail]()
    var isSearching = false
    var recipientID: String!
    var recipientImg: String!
    var recipientName: String!
    var Ref: String!

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            table.reloadData()
        } else {
            isSearching = true
            filteredResults = results.filter({$0.username.lowercased().contains((searchBar.text?.lowercased())!)})
            table.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredResults.count
        } else {
            return results.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching{
            let Det = self.filteredResults[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search") as? SearchCell {
                cell.configureCell(Det: Det)
                return cell
            } else {
                return SearchCell()
            }

        } else {
            let Det = self.results[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search") as? SearchCell {
                cell.configureCell(Det: Det)
                return cell
            } else {
                return SearchCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.reloadData()
        if isSearching{
            recipientID = filteredResults[indexPath.row].ID
            recipientImg = filteredResults[indexPath.row].imgURL
            recipientName = filteredResults[indexPath.row].username
        } else {
            recipientID = results[indexPath.row].ID
            recipientImg = results[indexPath.row].imgURL
            recipientName = results[indexPath.row].username
        }
        performSegue(withIdentifier: "toMessages2", sender: nil)
    }
    
    
    @IBOutlet weak var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        Database.database().reference().child("users").observe(.value, with: {(snapshot) in
            self.results.removeAll()
            self.filteredResults.removeAll()
            let users = snapshot.children.allObjects as! [DataSnapshot]
            for data in users{
                if(data.key == self.currentUser){
                    continue
                }
                Database.database().reference().child("users").child(data.key).child("info").observe(.value, with: {(snapshot) in
                    if let dict = snapshot.value as? Dictionary<String, AnyObject>{
                        let Det = SearchDetail()
                        Det.username = dict["username"] as! String
                        Det.imgURL = dict["userImg"] as! String
                        Det.ID = data.key
                        self.results.append(Det)
                        self.results.sort(by: {$0.username < $1.username})
                        self.table.reloadData()
                    }
                })
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? Messages{
            dest.recipientID = recipientID
            dest.recipientImg = recipientImg
            dest.recipientName = recipientName
            dest.messageID = Ref
        }
    }
  
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
