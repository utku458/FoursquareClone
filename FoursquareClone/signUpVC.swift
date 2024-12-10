//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Utku Altınay on 27.11.2024.
//

import UIKit
import ParseCore

class signUpVC: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
      
        }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != ""{
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "Error", messageInput: "Kullanici adi veya sifre hatali")
        }
    
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != ""{
            let user = PFUser()
            
            user.username = userNameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { (succes, error) in
                if error != nil{
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                }
                else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Kullanici adi veya sifre bos veya hatali")
        }
    }
    
    
    func makeAlert(titleInput: String , messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: titleInput, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    


}

