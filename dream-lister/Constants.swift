//
//  Constants.swift
//  dream-lister
//
//  Created by Matt Byers on 24/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import Foundation

let BASE_URL = "https://dream-lister.herokuapp.com" //Change to heroku address, once hosted
let AUTH_URL = BASE_URL + "/auth"
let ITEMS_URL = BASE_URL + "/items"
let ITEM_URL = BASE_URL + "/item/" //This URL should have an item_id appended if get, put or delete

typealias DownloadComplete = () -> ()
