//
//  RegisterVC.swift
//  dream-lister
//
//  Created by Matt Byers on 25/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit
import Alamofire


class RegisterVC: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }

    @IBAction func registerPressed(_ sender: AnyObject) {
        if usernameField.text != "" && passwordField.text != "" && emailField.text != ""{
            tryRegister {
                print("Trying to dimiss")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func tryRegister(completed: @escaping DownloadComplete) {
        var reqBody = [String: AnyObject]()
        reqBody["username"] = usernameField.text as AnyObject?
        reqBody["email"] = emailField.text as AnyObject?
        reqBody["password"] = passwordField.text as AnyObject?
        
        print("Making request")
        Alamofire.request(AUTH_URL, method: .post, parameters: reqBody, encoding: JSONEncoding.default).responseJSON { response in
            let result = response.result
            if let json = result.value as? Dictionary<String, AnyObject> {
                if let token = json["data"] as? String {
                    print("Got a token yo")
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
