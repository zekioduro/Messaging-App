//
//  ViewController.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/8/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var incorrect: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var userUid: String!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func enable2(_ sender: Any) {
        if emailField.text != nil && emailField.text != "" && passwordField.text != nil && passwordField.text != ""{
            loginButton.isEnabled = true
        } else {
           loginButton.isEnabled = false
        }
    }
    


    
    
    @IBAction func login(_ sender: AnyObject) {
        
        if let email = emailField.text, let password = passwordField.text{
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user,error) in
                
                if error == nil{
                    self.userUid = user?.uid
                    
                    KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                    
                    self.incorrect.isHidden = true
                    
                    self.performSegue(withIdentifier: "toChat", sender: nil)
                } else {
                    self.incorrect.isHidden = false
                }
            })
        }
        
    }
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrect.isHidden = true
        emailField.delegate = self
        passwordField.delegate = self
        loginButton.isEnabled = false
        
        
        
        
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat"{
            if let destination = segue.destination as? Chat{
                destination.currentUser = self.userUid
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    

}

