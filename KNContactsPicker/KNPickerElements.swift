//
//  KNContactPickerButtons.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 13/11/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

struct KNPickerElements {
    
    private static let PICK_CONTACT_ICON            = "person.crop.circle.badge.checkmark"
    private static let PICK_CONTACT_FILLED_ICON     = "person.crop.circle.fill.badge.checkmark"
    private static let CLEAR_SELECTION_ICON         = "trash.circle"
    private static let CLEAR_SELECTION_FILLED_ICON  = "trash.circle.fill"
    
    static func selectButton(_ count: Int, action: Selector, target: UIViewController, settings: KNPickerSettings) -> UIBarButtonItem {
        let rightButton: UIButton = UIButton(type: .system)
        let pickString = count > 0 ?
            String(format: settings.selectedContactsPickButtonTitle, count) :
            settings.defaultPickButtonTitle
               
               rightButton.setTitle(pickString, for: .normal)
               rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
               rightButton.addTarget(target, action: action, for: .touchUpInside)
               
               if #available(iOS 13.0, *) {
                   if (count > 0 ) {
                       let string = count == 0 ? PICK_CONTACT_ICON : PICK_CONTACT_FILLED_ICON
                       let contactsImage = UIImage(systemName: string)
                       rightButton.setImage(contactsImage, for: .normal)
                       rightButton.semanticContentAttribute = .forceRightToLeft
                   }
                 
                   rightButton.tintColor = .systemBlue
               }
               else {
                   rightButton.tintColor = .blue
               }
               
               rightButton.sizeToFit()
               return UIBarButtonItem(customView: rightButton)
    }
    
    static func clearButton(_ count: Int, action: Selector, target: UIViewController,  settings: KNPickerSettings) -> UIBarButtonItem {
        let leftButton: UIButton = UIButton(type: .system)
        leftButton.setTitle(settings.clearSelectionButtonTitle, for: .normal)
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        leftButton.addTarget(target, action: action, for: .touchUpInside)
        
        if #available(iOS 13.0, *) {
            let clearImageString = count == 0 ? CLEAR_SELECTION_ICON : CLEAR_SELECTION_FILLED_ICON
            let clearImage = UIImage(systemName: clearImageString)
            leftButton.setImage(clearImage, for: .normal)
            leftButton.tintColor = .secondaryLabel
        }
        else {
            leftButton.tintColor = .lightGray
        }
        leftButton.isUserInteractionEnabled = count > 0

        leftButton.sizeToFit()
        return UIBarButtonItem(customView: leftButton)
    }
    
    static func pullToDismissAlert(count: Int, contactName: String, settings: KNPickerSettings, controller: KNContactsPickerController) -> UIAlertController {
        let message = (count > 1 && !contactName.isEmpty) ?
                    String(format: settings.pullToDismissMessageMultipleContacts, contactName, count.advanced(by: -1)) :
                    String(format: settings.pullToDismissMessageSingleContact, contactName)

                let alert = UIAlertController(title: settings.pullToDismissAlertTitle, message: message, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: settings.pullToDismissCompleteSelectionButtonTitle,
                                              style: .default) { _ in
                    controller.presentationDelegate?.contactPickerDidSelect(controller)
                    
                })
                
                alert.addAction(UIAlertAction(title: settings.pullToDismissDiscardSelectionButtonTitle,
                                              style: .destructive) { _ in
                    controller.presentationDelegate?.contactPickerDidCancel(controller)
                })
                
                alert.addAction(UIAlertAction(title: settings.pullToDismissCancelButtonTitle,
                                              style: .cancel, handler: nil))
                
        return alert
    }
    
    static func searchResultsController(settings: KNPickerSettings, controller: KNContactsPickerController) -> UISearchController {
        
        let searchResultsController = UISearchController(searchResultsController: nil)
        searchResultsController.searchResultsUpdater = controller
              
              searchResultsController.hidesNavigationBarDuringPresentation = false
              searchResultsController.obscuresBackgroundDuringPresentation = false
              searchResultsController.navigationItem.largeTitleDisplayMode = .always
              searchResultsController.searchBar.placeholder = settings.searchBarPlaceholder
              
            controller.definesPresentationContext = true
              
              if #available(iOS 13.0, *) {
                  
                  let transparentAppearance = UINavigationBarAppearance().copy()
                  transparentAppearance.configureWithTransparentBackground()
                  
                  searchResultsController.navigationItem.standardAppearance = transparentAppearance
                  searchResultsController.navigationItem.compactAppearance = transparentAppearance
                  searchResultsController.navigationItem.scrollEdgeAppearance = transparentAppearance
              }
              
        return searchResultsController
    }
}
