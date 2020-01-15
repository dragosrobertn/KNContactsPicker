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
    weak var contactPickingDelegate: KNContactPickingDelegate!
    private var contacts: [CNContact] = []
    
    var tableViewStyle: UITableView.Style {
        get {
            if #available(iOS 13.0, *) {
                return UITableView.Style.insetGrouped
            }
            return UITableView.Style.grouped
        }
    }
    
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
        let controller = KNContactsPickerController(style: tableViewStyle)
        
        controller.settings = settings
        controller.delegate = contactPickingDelegate
        controller.presentationDelegate = self
        controller.contacts = sortingOutcome?.sortedContacts ?? []
        controller.sortedContacts = sortingOutcome?.contactsSortedInSections ?? [:]
        controller.sections = sortingOutcome?.sections ?? []
        
        return controller
    }
    
    func fetchContacts() {
      
        switch settings.pickerContactsSource {
        case .userProvided:
            self.sortingOutcome = KNContactUtils.sortContactsIntoSections(contacts: settings.pickerContactsList, sortingType: settings.displayContactsSortedBy)
        case .default:
            requestAndSortContacts()
        }
        
    }
    
    private func requestAndSortContacts() {
        switch KNContactsAuthorisation.requestAccess(conditionToEnableContact: settings.conditionToDisplayContact) {
        case .success(let resultContacts):
            self.sortingOutcome = KNContactUtils.sortContactsIntoSections(contacts: resultContacts, sortingType: settings.displayContactsSortedBy)
            
        case .failure(let failureReason):
            if failureReason != .pendingAuthorisation {
                self.dismiss(animated: true, completion: {
                    self.contactPickingDelegate?.contactPicker(didFailPicking: failureReason)
                })
            }
        }
    }
    
}
