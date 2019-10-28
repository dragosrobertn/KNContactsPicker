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
    
    var all: [CNContact] = []
    var selected: Set<CNContact> = [] {
        willSet(newValue) {
            self.updateTitleWithSelected(contactsCount: newValue.count)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(KNContactCell.self, forCellReuseIdentifier: CELL_ID)
        self.updateTitleWithSelected()
        self.fetchContacts()
    }
    
    func updateTitleWithSelected(contactsCount: Int = 0) {
         self.title = contactsCount > 0 ? String.init(format: "%d selected", contactsCount) : "Contacts"
    }

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! KNContactCell
        
        let contact = all[indexPath.row]

        let image = contact.getImageOrInitials(bounds: cell.profileImageView.bounds, scaled: cell.imageView?.shouldScale ?? true)
        
        cell.nameLabel.text = contact.getFullName(using: formatter)
        cell.profileImageView.image = image
        cell.profileImageView.highlightedImage = image
        
        let cellIsSelected = selected.contains(contact)
        cell.setSelected(cellIsSelected, animated: false)
 
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    fileprivate func toggleSelected(_ contact: CNContact) {
        if selected.contains(contact) {
            selected.remove(contact)
        }
        else {
            selected.insert(contact)
        }
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = all[indexPath.row]
        self.toggleSelected(contact)
        self.tableView.reloadData()
    }
    
    func fetchContacts() {
        switch KNContactsAuthorisation.checkAuthorisationStatus() {
        case .authorized:
            let result = KNContactsAuthorisation.requestAccess()
            switch result {
            case .success(let resultContacts):
                all = resultContacts.sorted(by: {(contact1, contact2) in contact1.familyName < contact2.familyName })
            case .failure(let f):
                print(f)
            }
        case .notDetermined:
            let result = KNContactsAuthorisation.requestAccess()
            switch result {
            case .success:
                self.fetchContacts()
            case .failure(let f):
                print(f)
            }
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }

}
