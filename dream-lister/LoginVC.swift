//
//  LoginVC.swift
//  dream-lister
//
//  Created by Matt Byers on 23/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Need to check the user doesn't already have a token here, then change view if they do.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "RegisterVC", sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        if usernameField.text != "" && passwordField.text != ""{
            tryAuth {
                self.performSegue(withIdentifier: "MainVC", sender: nil)
            }
        }
        
    }
    
    func tryAuth(completed: @escaping DownloadComplete) {
        var reqBody = [String: AnyObject]()
        reqBody["username"] = usernameField.text as AnyObject?
        reqBody["password"] = passwordField.text as AnyObject?
        
        print("Making request")
        Alamofire.request(AUTH_URL, method: .put, parameters: reqBody, encoding: JSONEncoding.default).responseJSON { response in
            let result = response.result
            if let json = result.value as? Dictionary<String, AnyObject> {
                if let token = json["data"] as? String {
                    //Need to store token in user defaults here
                    self.defaults.set(token, forKey: "token")
                    completed()
                } else {
                    self.statusLabel.text = json["message"] as? String
                    self.statusLabel.isHidden = false
                }
            }
        }

    }


}
