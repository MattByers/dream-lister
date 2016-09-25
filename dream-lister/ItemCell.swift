//
//  ItemCell.swift
//  dream-lister
//
//  Created by Matt Byers on 18/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    func configureCell(item: Item) {
        title.text = item.name
        price.text = item.price
        desc.text = item.desc
//        let image = item.imageURL as? Image
//        thumb.image = image?.image as? UIImage
        
    }

}
