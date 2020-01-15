//
//  KNContactsTableViewController.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

protocol KNContactsPickerControllerPresentationDelegate: class {
    func contactPickerDidCancel(_ picker: KNContactsPickerController)
    func contactPickerDidSelect(_ picker: KNContactsPickerController)
}

class KNContactsPickerController: UITableViewController {
    public var settings: KNPickerSettings = KNPickerSettings()
    public weak var delegate: KNContactPickingDelegate?
    public weak var presentationDelegate: KNContactsPickerControllerPresentationDelegate?
    
    private let CELL_ID = "KNContactCell"
    private let formatter =  CNContactFormatter()
    
    var searchResultsController: UISearchController?
    var contacts: [CNContact] = []
    var filteredContacts: [CNContact] = []
    var sortedContacts: [String: [CNContact]] = [:]
    var sections: [String] = []
    
    private var selectedContacts: Set<CNContact> = [] {
        willSet(newValue) {
            self.configureButtons(count: newValue.count)
        }
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var shouldDisableSelection: Bool {
        get { return settings.selectionMode == .singleDeselectOthers && selectedContacts.count == 1 }
    }
    
    var isSearchBarEmpty: Bool {
        return searchResultsController?.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return (searchResultsController?.isActive ?? false) && !isSearchBarEmpty
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(KNContactCell.self, forCellReuseIdentifier: CELL_ID)
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = settings.pickerTitle
        self.tableView.sectionIndexColor = UIColor.lightGray
        
        self.searchResultsController = KNPickerElements.searchResultsController(settings: settings, controller: self)
        self.navigationItem.searchController = searchResultsController
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.configureButtons(count: self.selectedContacts.count)
    }
    
    func configureButtons(count: Int) {
        self.navigationItem.rightBarButtonItem = KNPickerElements.selectButton(count, action: #selector(completeSelection), target: self, settings: settings)
        
        if count > 0 {
            self.navigationItem.leftBarButtonItem = KNPickerElements.clearButton(count, action: #selector(clearSelected), target: self, settings: settings)
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    public func getSelectedContacts() -> [CNContact] {
        return Array(selectedContacts)
    }
    
    @objc func completeSelection() {
        self.presentationDelegate?.contactPickerDidSelect(self)
    }
    
    @objc func clearSelected() {
        self.selectedContacts.removeAll()
    }
    
    fileprivate func toggleSelected(_ contact: CNContact) {
        if (settings.selectionMode == .singleReselect) {
            self.clearSelected()
            selectedContacts.insert(contact)
        }
        else if selectedContacts.contains(contact) {
            selectedContacts.remove(contact)
        } else {
            selectedContacts.insert(contact)
        }
    }
    
    fileprivate func confirmCancel() {
        let firstContactsName = selectedContacts.first?.getFullName(using: formatter) ?? ""
        
        let alert = KNPickerElements.pullToDismissAlert(count: selectedContacts.count,
                                                        contactName: firstContactsName,
                                                        settings: settings,
                                                        controller: self)
        
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
    
    // MARK: Table View Sections
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : self.sections.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering ? settings.searchResultSectionTitle : self.sections[section]
    }
    
    // MARK: Table View Rows
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? self.filteredContacts.count : self.sortedContacts[self.sections[section]]?.count ?? 0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! KNContactCell
        let contact = self.getContact(at: indexPath)
        let contactModel = KNContactCellModel(contact: contact, settings: settings, formatter: formatter)
        
        let disabled = ( shouldDisableSelection && !selectedContacts.contains(contact) ) || settings.conditionToDisableContact(contact)
        
        let selected = selectedContacts.contains(contact)
        cell.set(contactModel: contactModel)
        
        cell.setDisabled(disabled: disabled)
        cell.setSelected(selected, animated: false)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.getContact(at: indexPath)
        self.toggleSelected(contact)
    }
    
    // MARK: Section Index Title
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
}

// MARK: SEARCH RESULTS UPDATING
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

// MARK: PRESENTATION DELEGATE
extension KNContactsPickerController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return selectedContacts.count == 0
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.confirmCancel()
    }
    
}
