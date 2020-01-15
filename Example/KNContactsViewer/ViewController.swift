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
        settings.conditionToDisplayContact = { _ in
            return true
        }
        settings.conditionToDisableContact = { [weak self] contact in
            return self?.contacts.contains(contact) ?? false
        }

        let controller = KNContactsPicker(delegate: self, settings: settings)
        
        self.navigationController?.present(controller, animated: true, completion: nil)
          
    }
    @IBAction func clearContacts(_ sender: Any) {
        self.contacts = []
        self.contactsTableView.reloadData()
    }
    
    @IBAction func showSettingsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts Picker"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
        
        settings.pickerTitle = "Pick"
        settings.contactCellUserProvidedImage = UIImage(named: "contact-cell-image.pdf")
        settings.contactInitialsBackgroundColor = GradientColors(top: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), bottom: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
           guard let newVC = segue.destination as? SettingsViewController else { return }
           newVC.settingsDelegate = self
           newVC.settings = self.settings
       }
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

extension ViewController: SettingsViewControllerDelegate {
    func dismissed(with settings: KNPickerSettings) {
        self.settings = settings
    }
}
