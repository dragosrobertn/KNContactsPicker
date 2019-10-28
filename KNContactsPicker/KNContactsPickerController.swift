//
//  KNContactsTableViewController.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

open class KNContactsPickerController: UITableViewController {
    let CELL_ID = "KNContactCell"
    let formatter =  CNContactFormatter()
    
    var contacts: [CNContact] = []
    var filtered: [CNContact] = []
    var selected: Set<CNContact> = [] {
        willSet(newValue) {
            self.updateTitleWithSelected(contactsCount: newValue.count)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(KNContactCell.self, forCellReuseIdentifier: CELL_ID)

        self.updateTitleWithSelected()
        self.initializeSearchBar()
        self.fetchContacts()
    }
    
    func initializeSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.navigationItem.largeTitleDisplayMode = .always
        searchController.searchBar.placeholder = "Search contacts"
      
        
        if #available(iOS 13.0, *) {
       
            let transparentAppearance = UINavigationBarAppearance().copy()
            transparentAppearance.configureWithTransparentBackground()
            
            searchController.navigationItem.standardAppearance = transparentAppearance
            searchController.navigationItem.compactAppearance = transparentAppearance
            searchController.navigationItem.scrollEdgeAppearance = transparentAppearance
        }
        
        self.navigationItem.searchController = searchController
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
   }
    
    func updateTitleWithSelected(contactsCount: Int = 0) {
        let title = contactsCount > 0 ? String.init(format: "%d selected", contactsCount) : "Contacts"
        
        self.searchController.navigationItem.title = title
        self.navigationItem.title = title
    }

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? "Results" : "Contacts"
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filtered.count
        }
        
        return contacts.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! KNContactCell
        
        let contact = self.getContact(at: indexPath)
       
        let image = contact.getImageOrInitials(bounds: cell.profileImageView.bounds, scaled: cell.imageView?.shouldScale ?? true)
        
        cell.nameLabel.text = contact.getFullName(using: formatter)
        cell.profileImageView.image = image
        cell.profileImageView.highlightedImage = image
        
        cell.setSelected(selected.contains(contact), animated: false)
 
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    fileprivate func toggleSelected(_ contact: CNContact) {
        if selected.contains(contact) {
            selected.remove(contact)
        } else {
            selected.insert(contact)
        }
    }
    
    func getContact(at indexPath: IndexPath) -> CNContact {
        return isFiltering ? filtered[indexPath.row] : contacts[indexPath.row]
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.getContact(at: indexPath)
        self.toggleSelected(contact)
        self.tableView.reloadData()
    }
    
    func fetchContacts() {
        
        let result = KNContactsAuthorisation.requestAccess()
        switch result {
            
        case .success(let resultContacts):
                print("Success")
                self.contacts = resultContacts.sorted(by: {(c1, c2) in c1.familyName < c2.familyName })
                self.tableView.reloadData()
            
        case .failure(let f):
                print("Failure")
                if f != .pendingAuthorisation {
                    self.dismiss(animated: true)
                    print(f)
                }
                
                break
        }
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.filtered = contacts.filter({( currentContact: CNContact) -> Bool in
            return (currentContact.getFullName(using: formatter).lowercased().contains(searchText.lowercased()))
        })
        
        self.tableView.reloadData()
    }

}

extension KNContactsPickerController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
}
