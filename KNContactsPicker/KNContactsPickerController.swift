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
    
    var allContacts: [CNContact] = []
    var selectedContacts: Set<CNContact> = [] {
        willSet(newValue) {
            self.updateTitleWith(value: newValue.count)
        }
    }
    let formatter =  CNContactFormatter()
    
    var initialColor: UIColor? = nil

    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.updateTitleWith(value: 0)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

        self.tableView.register(KNContactCell.self, forCellReuseIdentifier: "KNContactCell")
        self.fetchContacts()
    }
    
    func updateTitleWith(value: Int) {
         self.title = value > 0 ? String.init(format: "%d selected", value) : "Contacts"
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KNContactCell", for: indexPath) as! KNContactCell
        
        let contact = allContacts[indexPath.row]
        let name = formatter.string(from: contact)


        let image = contact.getImageOrInitials(bounds: cell.profileImageView.bounds, scaled: cell.imageView?.shouldScale ?? true)
        
        cell.nameLabel.text = name
        cell.profileImageView.image = image
        
        let selected = selectedContacts.contains(contact)
        cell.setSelected(selected, animated: false)
 
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    fileprivate func toggleSelected(_ contact: CNContact) {
        if selectedContacts.contains(contact) {
            selectedContacts.remove(contact)
        }
        else {
            selectedContacts.insert(contact)
        }
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = allContacts[indexPath.row]
        
        toggleSelected(contact)
        

//        self.updateTitle()
        self.tableView.reloadData()
    }
    
    func fetchContacts() {
        switch KNContactsAuthorisation.checkAuthorisationStatus() {
        case .authorized:
            let result = KNContactsAuthorisation.requestAccess()
            switch result {
            case .success(let resultContacts):
                allContacts = resultContacts.sorted(by: {(contact1, contact2) in contact1.familyName < contact2.familyName })
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
