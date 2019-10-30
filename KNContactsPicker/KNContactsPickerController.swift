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
    public var settings: KNPickerSettings = KNPickerSettings()
    
    let CELL_ID = "KNContactCell"
    let formatter =  CNContactFormatter()
    
    var contacts: [CNContact] = []
    var filtered: [CNContact] = []
    
    var selected: Set<CNContact> = [] {
        willSet(newValue) {
            self.updateSelectedIndicator(contactsCount: newValue.count)
        }
    }
    
    let searchResultsController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchResultsController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchResultsController.isActive && !isSearchBarEmpty
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(KNContactCell.self, forCellReuseIdentifier: CELL_ID)
        self.navigationItem.title = settings.pickerTitle
        self.updateSelectedIndicator()
        self.initializeSearchBar()
        self.configureButtons()
        self.fetchContacts()
    }
    
    func configureButtons() {
        let rightButton: UIButton = UIButton(type: .system)
        rightButton.setTitle("Done ", for: .normal)
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        rightButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
        
        if #available(iOS 13.0, *) {
            let contactSelectImage = UIImage(systemName: "person.crop.circle.fill.badge.checkmark")
            rightButton.setImage(contactSelectImage, for: .normal)
            rightButton.semanticContentAttribute = .forceRightToLeft
        }
        
        rightButton.sizeToFit()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.leftBarButtonItem = self.getLeftButton(count: 0)
        
    }
    
    func initializeSearchBar() {
        
        searchResultsController.searchResultsUpdater = self
        
        searchResultsController.hidesNavigationBarDuringPresentation = false
        searchResultsController.obscuresBackgroundDuringPresentation = false
        searchResultsController.navigationItem.largeTitleDisplayMode = .always
        searchResultsController.searchBar.placeholder = settings.searchBarPlaceholder
      
        definesPresentationContext = true
        
        if #available(iOS 13.0, *) {
       
            let transparentAppearance = UINavigationBarAppearance().copy()
            transparentAppearance.configureWithTransparentBackground()
            
            searchResultsController.navigationItem.standardAppearance = transparentAppearance
            searchResultsController.navigationItem.compactAppearance = transparentAppearance
            searchResultsController.navigationItem.scrollEdgeAppearance = transparentAppearance
        }
        
        self.navigationItem.searchController = searchResultsController
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
   }
    
    func getLeftButton(count: Int) -> UIBarButtonItem {
        let leftButton: UIButton = UIButton(type: .system)
        leftButton.setTitle(String.init(format: "%d", count), for: .normal)
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        leftButton.tintColor = .gray
        leftButton.isUserInteractionEnabled = false
        
        if #available(iOS 13.0, *) {
           var string = "person"
            if (count == 1 ) {
                string = "person.fill"
            }
            else if (count == 2 || count == 3){
                string = String.init(format: "person.%d.fill", count)
            } else if (count > 3){
                string = "person.3.fill"
            }
            
           let contactsImage = UIImage(systemName: string)
           leftButton.setImage(contactsImage, for: .normal)
       }
        leftButton.sizeToFit()
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    @objc func finish() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSelectedIndicator(contactsCount: Int = 0) {
        self.navigationItem.leftBarButtonItem = self.getLeftButton(count: contactsCount)
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
        let disabled = false
        
        cell.nameLabel.text = contact.getFullName(using: formatter)
        cell.profileImageView.image = image
        cell.profileImageView.highlightedImage = image
        
        cell.setSelected(selected.contains(contact), animated: false)
        cell.setDisabled(disabled: disabled)
 
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
        
        switch KNContactsAuthorisation.requestAccess() {
            
        case .success(let resultContacts):
                print("Success")
                self.contacts = resultContacts.sorted(by: {(c1, c2) in c1.familyName < c2.familyName })
                self.tableView.reloadData()
            
        case .failure(let failureReason):
                print("Failure")
                if failureReason != .pendingAuthorisation {
                    self.dismiss(animated: true)
                    print(failureReason)
                }
                
                break
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
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
