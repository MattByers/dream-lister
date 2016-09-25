//
//  Item.swift
//  dream-lister
//
//  Created by Matt Byers on 23/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import Foundation
import Alamofire

class Item {
    
    private var _id: Int!
    private var _name: String = ""
    private var _price: Double = 0.0
    private var _desc: String = ""
    private var _imageURL: String = ""
    private var _store: String = ""
    
    var id: Int {
        get {
            return _id
        } set {
            _id = newValue
        }
        
    }
    var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
    var price: String {
        get {
            return "$\(_price)"
        } set {
            _price = (newValue as NSString).doubleValue
        }
    }
    var doublePrice: Double{
        get {
            return _price
        } set {
            _price = newValue
        }
        
    }
    var desc: String {
        get {
            return _desc
        } set {
            _desc = newValue
        }
    }
    var imageURL: String {
        get {
            return _imageURL
        } set {
            _imageURL = newValue
        }
    }
    var store: String {
        get {
            return _store
        } set {
            _store = newValue
        }
    }
    
    init() {
        
    }
    
    init(itemJSON: Dictionary<String, AnyObject>) {
        if let id = itemJSON["item_id"] as? Int{
            _id = id
        }
        if let name = itemJSON["item_name"] as? String {
            _name = name
        }
        if let price = itemJSON["item_price"] as? String {
            let doublePrice = (price as NSString).doubleValue
            _price = doublePrice
        }
        if let desc = itemJSON["item_desc"] as? String {
            _desc = desc
        }
        if let imageURL = itemJSON["item_image"] as? String {
            _imageURL = imageURL
        }
        if let store = itemJSON["item_store"] as? String {
            _store = store
        }
    }
}
