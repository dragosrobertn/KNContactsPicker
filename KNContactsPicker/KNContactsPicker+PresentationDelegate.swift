//
//  KNContactsPicker+PresentationDelegate.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 14/01/2020.
//  Copyright © 2020 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

extension KNContactsPicker: KNContactsPickerControllerPresentationDelegate {
    
    func contactPickerDidCancel(_ picker: KNContactsPickerController) {
        self.dismiss(animated: true, completion: {
            self.contactPickingDelegate?.contactPicker(didFailPicking: KNContactFetchingError.userCancelled)
        })
    }
    
    func contactPickerDidSelect(_ picker: KNContactsPickerController) {
        let contacts = picker.getSelectedContacts()
        
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
