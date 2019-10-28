//
//  KNContactsPicker.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 24/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

open class KNContactsPicker: UINavigationController {
    
    var resultSearchController = UISearchController()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = UITableView.Style.insetGrouped
        } else {
            style = UITableView.Style.grouped
        }
        let controller = KNContactsPickerController(style: style)
        self.navigationBar.prefersLargeTitles = true
        self.initializeSearchBar()
        self.viewControllers.append(controller)
    
//        self.navigationController?.present(controller, animated: true, completion: nil)

    }
    
    
    func initializeSearchBar() {
        
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        //            controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.delegate = self
        //            self.tableView.tableHeaderView = controller.searchBar

        self.navigationItem.searchController = controller
                      
                      // Make the search bar always visible.
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension KNContactsPicker: UISearchBarDelegate {
    
}

extension KNContactsPicker: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = resultSearchController.searchBar.text , searchController.isActive {
                   
        let predicate: NSPredicate
        if searchText.count > 0 {
               predicate = CNContact.predicateForContacts(matchingName: searchText)
           } else {
               predicate = CNContact.predicateForContactsInContainer(withIdentifier: CNContactStore().defaultContainerIdentifier())
           }
           
           let store = CNContactStore()
           do {
//                       filteredContacts = try store.unifiedContacts(matching: predicate, keysToFetch: allowedContactKeys())
               //print("\(filteredContacts.count) count")
               
//                       self.tableView.reloadData()
               
           }
           catch {
               print("Error!")
           }
       }
    }
    
}
