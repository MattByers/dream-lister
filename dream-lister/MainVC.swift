//
//  MainVC.swift
//  dream-lister
//
//  Created by Matt Byers on 18/09/16.
//  Copyright © 2016 Matt Byers. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    var items = [Item]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //generateTestData()
        //attemptFetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items.removeAll()
        downloadItems {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
//        let item = controller.object(at: indexPath as IndexPath)
//        cell.configureCell(item: item)
        let item = items[indexPath.row]
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    @IBAction func segmentedControllerAction(_ sender: AnyObject) {
        if segment.selectedSegmentIndex == 0 {
            items.removeAll()
            downloadItems {
                self.tableView.reloadData()
            }
        } else if segment.selectedSegmentIndex == 1 {
            items.sort(by: {$0.doublePrice < $1.doublePrice})
            tableView.reloadData()
        } else {
            items.sort(by: {$0.name < $1.name})
            tableView.reloadData()
        }
    }
    
    func downloadItems(completed: @escaping DownloadComplete) {
        if let token = defaults.string(forKey: "token") {
            let authHeader = ["Authorization": "Bearer " + token]
            let itemsURL = URL(string: ITEMS_URL)!
            Alamofire.request(itemsURL, headers: authHeader).responseJSON { response in
                let result = response.result
                print(result)
                
                if let json = result.value as? Dictionary<String, AnyObject> {
                    if let jsonItems = json["data"] as? [Dictionary<String, AnyObject>] {
                        for obj in jsonItems {
                            let item = Item(itemJSON: obj)
                            print("Appendning item")
                            self.items.append(item)
                            
                        }
                    }
                }
                completed()
            }
        } else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
        }
        
        
    }
    
    

    
//    func generateTestData() {
//        let item1 = Item(context: context)
//        
//        item1.title = "MacBook Pro"
//        item1.price = 2800.0
//        item1.details = "Can't wait until the new MacBook Pro's are released"
//        
//        let item2 = Item(context: context)
//        item2.title = "iPhone 7"
//        item2.price = 1400.0
//        item2.details = "iPhone 7 is so good"
//        
//        ad.saveContext()
//        
//    }


}


