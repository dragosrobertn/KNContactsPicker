//
//  KNContactsPicker.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 24/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

open class KNContactsPicker: UINavigationController {
    
    var settings: KNPickerSettings = KNPickerSettings()
    var contactPickingDelegate: KNContactPickingDelegate?
    
    private var sortingOutcome: KNSortingOutcome?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.fetchContacts()
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        let contactPickerController = self.getContactsPicker()
        
        self.presentationController?.delegate = contactPickerController
        self.viewControllers.append(contactPickerController)
    }
    
    convenience public init(delegate: KNContactPickingDelegate?, settings: KNPickerSettings) {
        self.init()
        self.contactPickingDelegate = delegate
        self.settings = settings
    }
    
    func getContactsPicker() -> KNContactsPickerController {
        var style: UITableView.Style {
            get {
                if #available(iOS 13.0, *) {
                    return UITableView.Style.insetGrouped
                } else {
                    return UITableView.Style.grouped
                }
            }
        }
        
        let controller = KNContactsPickerController(style: style)
        
        controller.settings = settings
        controller.delegate = contactPickingDelegate
        controller.presentationDelegate = self
        controller.contacts = sortingOutcome?.sortedContacts ?? []
        controller.sortedContacts = sortingOutcome?.contactsSortedInSections ?? [:]
        controller.sections = sortingOutcome?.sections ?? []
        
        return controller
    }
    
    func fetchContacts() {
        
        switch KNContactsAuthorisation.requestAccess(conditionToEnableContact: settings.conditionToEnableContact) {
        case .success(let resultContacts):
            self.sortingOutcome = KNContactUtils.sortContactsIntoSections(contacts: resultContacts, sortingType: .familyName)
            
        case .failure(let failureReason):
            if failureReason != .pendingAuthorisation {
                self.dismiss(animated: true, completion: {
                    self.contactPickingDelegate?.contactPicker(didFailPicking: failureReason)
                })
            }
        }
    }
    
}

extension KNContactsPicker: KNContactsPickerControllerPresentationDelegate {
    
    func contactPickerDidCancel(_ picker: KNContactsPickerController) {
        self.dismiss(animated: true, completion: {
            self.contactPickingDelegate?.contactPicker(didFailPicking: KNContactFetchingError.userCancelled)
        })
    }
    
    func contactPickerDidSelect(_ picker: KNContactsPickerController) {
        let contacts = picker.getSelectedContacts()
        
        print(contacts.count)
        self.dismiss(animated: true, completion: {
            if contacts.count > 1 {
                self.contactPickingDelegate?.contactPicker(didSelect: contacts)
            }
            else {
                guard let onlyContact = contacts.first else {
                    let error: Error = KNContactFetchingError.fetchRequestFailed
                    return (self.contactPickingDelegate?.contactPicker(didFailPicking: error))!
                }
                
                self.contactPickingDelegate?.contactPicker(didSelect: onlyContact)
            }
            
        })
    }
    
}
