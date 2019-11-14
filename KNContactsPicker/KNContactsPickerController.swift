//
//  KNContactsTableViewController.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

protocol KNContactsPickerControllerPresentationDelegate {
    func contactPickerDidCancel()
    func contactPickerDidFinish()
}

class KNContactsPickerController: UITableViewController {
    public var settings: KNPickerSettings = KNPickerSettings()
    public var delegate: KNContactPickingDelegate?
    public var presentationDelegate: KNContactsPickerControllerPresentationDelegate?
    
    let CELL_ID = "KNContactCell"
    let formatter =  CNContactFormatter()
    
    var contacts: [CNContact] = []
    var filteredContacts: [CNContact] = []
    
    var sortedContacts: [String: [CNContact]] = [:]
    var sections: [String] = []
    
    var selectedContacts: Set<CNContact> = [] {
        willSet(newValue) {
            self.configureButtons(count: newValue.count)
        }
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var shouldDisableSelection: Bool {
        get {
            return settings.selectionMode == .single && selectedContacts.count == 1
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
        self.tableView.sectionIndexColor = UIColor.lightGray
        self.initializeSearchBar()
        self.configureButtons(count: self.selectedContacts.count)
    }
    
    func configureButtons(count: Int) {
        self.navigationItem.rightBarButtonItem = KNContactPickerButtons.completeSelection(count, action: #selector(completeSelection), target: self)
        
        if count > 0 {
             self.navigationItem.leftBarButtonItem = KNContactPickerButtons.clearSelection(count, action: #selector(clearSelected), target: self)
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
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
    
    @objc func completeSelection() {
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
    
    @objc func clearSelected() {
        self.selectedContacts.removeAll()
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : self.sections.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? "Top name matches" : self.sections[section]
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
    
    fileprivate func confirmCancel() {
        let firstContactsName = selectedContacts.first?.getFullName(using: formatter) ?? ""
            
        
        let message = (selectedContacts.count > 1 && !firstContactsName.isEmpty) ?
            String(format: "You have selected %@ and %d other contacts.", firstContactsName, selectedContacts.count.advanced(by: -1)) :
            String(format: "You have selected %@.", firstContactsName)

        
        
        let alert = UIAlertController(title: "Dismiss", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Pick selected contacts", style: .default) { _ in
//            self.presentationDelegate?.contactPickerDidFinish()
            self.completeSelection()
        })
        
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.presentationDelegate?.contactPickerDidCancel()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // The popover should point at the Cancel button
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getContact(at indexPath: IndexPath) -> CNContact {
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
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
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


extension KNContactsPickerController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return selectedContacts.count == 0
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.confirmCancel()
    }
    
}
