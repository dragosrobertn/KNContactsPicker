//
//  SettingsViewController.swift
//  KNContactsViewer
//
//  Created by Dragos-Robert Neagu on 30/12/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import KNContactsPicker
import Contacts
import UIKit

protocol SettingsViewControllerDelegate {
    func dismissed(with settings: KNPickerSettings)
}

class SettingsViewController: UITableViewController {
    
    var settingsDelegate: SettingsViewControllerDelegate? = nil
    var settings: KNPickerSettings? = nil
    
    @IBOutlet weak var selectionPickerSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectionPickerSegmentedControl.selectedSegmentIndex = setPickerSelectionMode(settings?.selectionMode ?? .multiple)
        self.contactPickerModeChanged(self)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.title = "Settings"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        guard let actualDelegate = self.settingsDelegate else { return }
        actualDelegate.dismissed(with: self.settings ?? KNPickerSettings())
    }
    
    @IBAction func contactCellImagePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showContactCellImageOptions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactCellImageOptions" {
            if let viewController = segue.destination as? CellImageTableViewController {
                viewController.cellImageOptions = self.settings?.contactCellImageOptionOrder ?? viewController.cellImageOptions
                viewController.delegate = self
            }
        }
    }
    
    @IBAction func contactPickerModeChanged(_ sender: Any) {
        switch selectionPickerSegmentedControl.selectedSegmentIndex {
           case 0:
               settings?.selectionMode = .singleReselect
           case 1:
               settings?.selectionMode = .singleDeselectOthers
           case 2:
               settings?.selectionMode = .multiple
           default:
               break
        }
    }
    
    @IBAction func contactSourcePressed(_ sender: Any) {
        
        let deviceContactsAction = UIAlertAction(title: "Device", style: .default, handler: {
            _ in
            self.settings?.pickerContactsSource = .default
            self.settings?.pickerContactsList = []
        })
         let userPredefinedAction = UIAlertAction(title: "User Predefined", style: .default, handler: {
           _ in
            self.settings?.pickerContactsList = []
            var userPredefinedSettings = KNPickerSettings()
            userPredefinedSettings.selectionMode = .multiple
            userPredefinedSettings.pickerTitle = "Pick user predefined"
            let controller = KNContactsPicker(delegate: self, settings: userPredefinedSettings)
            self.navigationController?.present(controller, animated: true, completion: nil)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let actionController = UIAlertController(title: "Contacts Source", message: "Choose whether to display all contacts on device or from a predefined list.", preferredStyle: .actionSheet)

         actionController.addAction(deviceContactsAction)
         actionController.addAction(userPredefinedAction)
         actionController.addAction(cancelAction)

         self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func contactPickerTitlePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Contact Picker Title", message: "Enter title to display", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.settings?.pickerTitle ?? ""
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0] else { return }
            self.settings?.pickerTitle = textField.text ?? ""
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func contactsSortedByPressed(_ sender: Any) {
        let alertActionFamilyName = UIAlertAction(title: "Family Name", style: .default, handler: {
                  _ in self.settings?.displayContactsSortedBy = .familyName
              })
        let alertActionGivenName = UIAlertAction(title: "Given Name", style: .default, handler: {
          _ in self.settings?.displayContactsSortedBy = .givenName
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let controller = UIAlertController(title: "Sort contacts", message: "Option to sort contacts by", preferredStyle: .actionSheet)

        controller.addAction(alertActionFamilyName)
        controller.addAction(alertActionGivenName)
        controller.addAction(cancelAction)

        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func contactSubtitlePressed(_ sender: Any) {
        let alertActionNone = UIAlertAction(title: "None", style: .default, handler: {
            _ in self.settings?.subtitleDisplayInfo = .none
        })
        let alertActionPhone = UIAlertAction(title: "Phone number", style: .default, handler: {
            _ in self.settings?.subtitleDisplayInfo = .phoneNumber
        })
        let alertActionEmail = UIAlertAction(title: "Email", style: .default, handler: {
            _ in self.settings?.subtitleDisplayInfo = .emailAddress
        })
        let alertActionCompany = UIAlertAction(title: "Organization Name", style: .default, handler: {
            _ in self.settings?.subtitleDisplayInfo = .organizationName
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let controller = UIAlertController(title: "Display subtitle`", message: "Choose what information to display under the name", preferredStyle: .actionSheet)

        controller.addAction(alertActionNone)
        controller.addAction(alertActionPhone)
        controller.addAction(alertActionEmail)
        controller.addAction(alertActionCompany)
        controller.addAction(cancelAction)

        self.present(controller, animated: true, completion: nil)
}
    
    
    fileprivate func setPickerSelectionMode(_ selectionMode: KNContactsPickerMode) -> Int {
        switch settings?.selectionMode {
        case .multiple:
            return 2
        case .singleDeselectOthers:
            return 1
        case .singleReselect:
            return 0
        default:
            return 2
        }
    }

}


extension SettingsViewController: KNContactPickingDelegate {
    func contactPicker(didFailPicking error: Error) {
         print(error)
    }
    func contactPicker(didCancel error: Error) {
         print(error)
    }
    func contactPicker(didSelect contact: CNContact) {
         self.settings?.pickerContactsSource = .userProvided
        self.settings?.pickerContactsList.append(contact)
    }
    func contactPicker(didSelect contacts: [CNContact]) {
         self.settings?.pickerContactsSource = .userProvided
        self.settings?.pickerContactsList.append(contentsOf: contacts)
    }
}

extension SettingsViewController: CellImageOrderDelegate {
    func orderChanged(to cellImageOrder: [KNContactCellImageOptions]) {
        self.settings?.contactCellImageOptionOrder = cellImageOrder
    }
    
    
}
