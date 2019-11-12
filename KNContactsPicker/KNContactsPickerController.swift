//
//  KNContactsTableViewController.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

class KNContactsPickerController: UITableViewController {
    public var settings: KNPickerSettings = KNPickerSettings()
    public var delegate: KNContactPickingDelegate?
    
    let CELL_ID = "KNContactCell"
    let formatter =  CNContactFormatter()
    
    var contacts: [CNContact] = []
    var filteredContacts: [CNContact] = []
    
    var sortedContacts: [String: [CNContact]] = [:]
    var sections: [String] = []
    
    var selectedContacts: Set<CNContact> = [] {
        willSet(newValue) {
            self.updateSelectedIndicator(contactsCount: newValue.count)
        }
    }
    
    var shouldDisableSelection: Bool {
        get {
            return settings.pickerSelectionMode == .single && selectedContacts.count == 1
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
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = settings.pickerTitle
        self.updateSelectedIndicator()
        self.initializeSearchBar()
        self.configureButtons()
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
        self.navigationController?.dismiss(animated: true, completion: {
            if self.selectedContacts.count > 1 {
                self.delegate?.contactPicker(didSelect: Array(self.selectedContacts))
            }
            else {
                guard let onlyContact = Array(self.selectedContacts).first else {
                    let error: Error = KNContactFetchingError.fetchRequestFailed
                    return (self.delegate?.contactPicker(didFailPicking: error))!
                }
                
                self.delegate?.contactPicker(didSelect: onlyContact)
            }
           
        })
    }
    
    func updateSelectedIndicator(contactsCount: Int = 0) {
        self.navigationItem.leftBarButtonItem = self.getLeftButton(count: contactsCount)
    }

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return  isFiltering ? 1 : self.sections.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? "Results" : self.sections[section]
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? self.filteredContacts.count : self.sortedContacts[self.sections[section]]?.count ?? 0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! KNContactCell
        let contact = self.getContact(at: indexPath)
        let image = contact.getImageOrInitials(bounds: cell.profileImageView.bounds, scaled: cell.imageView?.shouldScale ?? true)
        let disabled = shouldDisableSelection && !selectedContacts.contains(contact)
        let selected = selectedContacts.contains(contact)
        
        cell.nameLabel.text = contact.getFullName(using: formatter)
        cell.profileImageView.image = image
        cell.profileImageView.highlightedImage = image
        
        cell.setDisabled(disabled: disabled)
        cell.setSelected(selected, animated: false)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    fileprivate func toggleSelected(_ contact: CNContact) {
        if selectedContacts.contains(contact) {
            selectedContacts.remove(contact)
        } else {
            selectedContacts.insert(contact)
        }
    }
    
    func getContact(at indexPath: IndexPath) -> CNContact {
        if isFiltering {
            return self.filteredContacts[indexPath.row]
        }
        else {
            let sectionContact = self.sortedContacts[self.sections[indexPath.section]]
            return sectionContact![indexPath.row]
        }
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.getContact(at: indexPath)
        self.toggleSelected(contact)
        self.tableView.reloadData()
    }

}

extension KNContactsPickerController: UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        let filteredContacts = self.contacts.filter({( currentContact: CNContact) -> Bool in
            return (currentContact.getFullName(using: formatter).lowercased().contains(searchText.lowercased()))
        })
        let outcome = KNContactUtils.sortContactsIntoSections(contacts: filteredContacts, sortingType: .givenName)
        self.filteredContacts = outcome.sortedContacts
    }

    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
         self.tableView.reloadData()
    }
}
