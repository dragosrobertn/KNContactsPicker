//
//  ViewController.swift
//  KNContactsViewer
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import KNContactsPicker
import ContactsUI

class ViewController: UIViewController, UITableViewDelegate {

    var settings = KNPickerSettings()
    var contacts: [CNContact] = []
    
    @IBAction func pickContactsButton(_ sender: Any) {
        settings.pickerTitle = "Pick"
        
        settings.conditionToDisplayContact = { contact in
          return true
        }
        settings.conditionToDisableContact = { contact in
            return self.contacts.contains(contact)
        }
              
        let controller = KNContactsPicker(delegate: self, settings: settings)
        
        self.navigationController?.present(controller, animated: true, completion: nil)
          
    }
    
    @IBOutlet weak var selectionPickerControl: UISegmentedControl!
    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBAction func selectionPickerModeChanged(_ sender: Any) {
        switch selectionPickerControl.selectedSegmentIndex
        {
        case 0:
            settings.selectionMode = .singleReselect
        case 1:
            settings.selectionMode = .singleDeselectOthers
        case 2:
            settings.selectionMode = .multiple
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts Picker"
        self.selectionPickerControl.selectedSegmentIndex = 2
        self.selectionPickerModeChanged(self)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        
        return cell
    }
}

extension ViewController: KNContactPickingDelegate {
    func contactPicker(didFailPicking error: Error) {
        print(error)
    }
    func contactPicker(didCancel error: Error) {
         print(error)
    }
    func contactPicker(didSelect contact: CNContact) {
        self.contacts.append(contact)
        self.contactsTableView.reloadData()
    }
    func contactPicker(didSelect contacts: [CNContact]) {
        self.contacts.append(contentsOf: contacts)
        self.contactsTableView.reloadData()
    }
}
