//
//  SignUp.swift
//  BuschLiviApp
//
//  Created by Zeki Oduro on 7/8/17.
//  Copyright © 2017 Zeki Oduro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var notUploaded: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    @IBOutlet weak var signUpError: UILabel!
    @IBOutlet weak var create: UIButton!
    
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    var userUid: String!
    
    
    @IBAction func enable2(_ sender: Any) {
        if firstNameField.text != "" && lastNameField.text != "" && emailField.text != "" && passwordField.text != "" && verifyPasswordField.text != "" && firstNameField.text != nil && lastNameField.text != nil && emailField.text != nil && passwordField.text != nil && verifyPasswordField.text != nil && imageSelected{
            if passwordField.text == verifyPasswordField.text{
                create.isEnabled = true
            } else {
                create.isEnabled = false
            }
        } else {
            create.isEnabled = false
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notUploaded.isHidden = true
        signUpError.isHidden = true
        create.isEnabled = false
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        emailField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        passwordField.delegate = self
        verifyPasswordField.delegate = self 
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Chat{
            destination.currentUser = self.userUid
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    func saveStuff(){
        var url: String!
        if let imgData = UIImageJPEGRepresentation(image.image!, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata, completion: {(metadata,error) in
                if error == nil{
                    url = metadata?.downloadURL()?.absoluteString
                    if let firstName = self.firstNameField.text, let lastName = self.lastNameField.text {
                        let username = "\(firstName) \(lastName)" 
                        
                        let userInfo = ["username": username, "userImg": url]
                        
                        Database.database().reference().child("users").child(self.userUid).child("info").setValue(userInfo)
                    }
                    
                }
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage]{
            image.image = img as? UIImage
            notUploaded.isHidden = true
            imageSelected = true
            if firstNameField.text != "" && lastNameField.text != "" && emailField.text != "" && passwordField.text != "" && verifyPasswordField.text != "" && firstNameField.text != nil && lastNameField.text != nil && emailField.text != nil && passwordField.text != nil && verifyPasswordField.text != nil {
                if passwordField.text == verifyPasswordField.text{
                    create.isEnabled = true
                } else {
                    create.isEnabled = false
                }
            } else {
                create.isEnabled = false
            }
            
            
        } else {
            notUploaded.isHidden = false
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func imagePicker(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {
            (user, error) in
            
            if error == nil{
                self.userUid = user?.uid
                self.signUpError.isHidden = true
                self.saveStuff()
                KeychainWrapper.standard.set(self.userUid, forKey: "uid")
                self.performSegue(withIdentifier: "toChat", sender: nil)
            } else {
                self.signUpError.isHidden = false
            }
        })
    }

    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
