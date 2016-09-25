//
//  ItemDetailsVC.swift
//  dream-lister
//
//  Created by Matt Byers on 19/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit
import Alamofire

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var imagePicker: UIButton!
    
    var defaults = UserDefaults.standard
    
    var stores = [String]()
    
    var itemToEdit: Item?
    var itemToCreate: Item?
    
    var imagePickerController: UIImagePickerController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove the text from nav bar back item
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.hideKeyboardWhenTappedAround()
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        loadStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.name
            priceField.text = "\(item.doublePrice)"
            detailsField.text = item.desc
            
//            let image = item.toImage as? Image
//            imagePreview.image = image?.image as? UIImage
            
            let store = item.store
            
            for i in 0..<stores.count {
                if stores[i] == store {
                    storePicker.selectRow(i, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    func loadStores() {
        stores.append("Apple Store")
        stores.append("Playtech")
        stores.append("JB Hi-Fi")
        stores.append("PB Technologies")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePreview.image = img
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func saveItemPressed(_ sender: AnyObject) {
        var item: Item!
        
        if itemToEdit == nil {
            itemToCreate = Item()
            item = itemToCreate
        } else {
            item = itemToEdit
        }
        
//        let picture = Image(context: context)
//        picture.image = imagePreview.image
//        
//        item.toImage = picture
        
        if let title = titleField.text {
            item.name = title
        }
        
        if let price = priceField.text {
            item.price = price
        }
        
        if let details = detailsField.text {
            item.desc = details
        }
        
        if(storePicker.selectedRow(inComponent: 0) < stores.count) {
            item.store = stores[storePicker.selectedRow(inComponent: 0)]
        }
        
        assert(itemToCreate != nil || itemToEdit != nil)
        attemptSave {
            _ = navigationController?.popViewController(animated: true)
        }
        
        
    }
    @IBAction func deleteItemPressed(_ sender: AnyObject) {
        //TODO: Delete Item from MainVC items....
        attemptDelete {
            _ = self.navigationController?.popViewController(animated: true)

        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imagePickerPressed(_ sender: AnyObject) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func attemptDelete(completed: @escaping DownloadComplete) {
        if let item = itemToEdit {
            let url = ITEM_URL + "\(item.id)"
            
            if let token = defaults.string(forKey: "token") {
                let authHeader = ["Authorization": "Bearer " + token]
                Alamofire.request(url, method: .delete, headers: authHeader).responseJSON { response in
                    print(response)
                    completed()
                }
            }

        }
        
    }
    
    func attemptSave(completed: DownloadComplete) {
        
        var url = ITEM_URL
        
        var method: HTTPMethod
        
        var item: Item!
        
        var reqBody = [String: AnyObject]()
        var newFields = [String: AnyObject]()
        
        if itemToEdit != nil {
            item = itemToEdit
            url = url + "\(item.id)"
            print(url)
            method = .put
            
        } else { //itemToCreate should not be nil here
            item = itemToCreate
            method = .post
        }
        newFields["item_name"] = item.name as AnyObject
        newFields["item_price"] = item.doublePrice as AnyObject
        newFields["item_desc"] = item.desc as AnyObject
        newFields["item_image"] = item.imageURL as AnyObject
        newFields["item_store"] = item.store as AnyObject
        reqBody["newFields"] = newFields as AnyObject?
        
        if let token = defaults.string(forKey: "token") {
            let authHeader = ["Authorization": "Bearer " + token]
            Alamofire.request(url, method: method, parameters: reqBody, encoding: JSONEncoding.default, headers: authHeader).responseJSON { response in
                //let result = response.result
                print(response)
            }
            completed()
        }
    }
    

}
