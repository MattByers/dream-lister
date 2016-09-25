//
//  VCExtension.swift
//  dream-lister
//
//  Created by Matt Byers on 25/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
