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
        
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = UITableView.Style.insetGrouped
        } else {
            style = UITableView.Style.grouped
        }
        self.fetchContacts()
        
        let controller = KNContactsPickerController(style: style)
        
        controller.settings = settings
        controller.delegate = contactPickingDelegate
        
        controller.contacts = sortingOutcome?.sortedContacts ?? []
        controller.sortedContacts = sortingOutcome?.contactsSortedInSections ?? [:]
        controller.sections = sortingOutcome?.sections ?? []
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.viewControllers.append(controller)
    }
    
    convenience public init(delegate: KNContactPickingDelegate?, settings: KNPickerSettings) {
        self.init()
        self.contactPickingDelegate = delegate
        self.settings = settings
    }
    
    func fetchContacts() {
        
        switch KNContactsAuthorisation.requestAccess() {
            
        case .success(let resultContacts):
                print("Success")
                self.sortingOutcome = KNContactUtils.sortContactsIntoSections(contacts: resultContacts, sortingType: .familyName)
               
            
        case .failure(let failureReason):
                print("Failure")
                if failureReason != .pendingAuthorisation {
                    self.dismiss(animated: true, completion: {
                        self.contactPickingDelegate?.contactPicker(didFailPicking: failureReason)
                    })
                    print(failureReason)
                }
                
                break
        }
    }
    
}
