//
//  KNContactPickerButtons.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 13/11/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

struct KNContactPickerButtons {
    
    static func completeSelection(_ count: Int, action: Selector, target: UIViewController) -> UIBarButtonItem {
        let rightButton: UIButton = UIButton(type: .system)
               let pickString = count > 0 ? String(format: "Select %d ", count) : "Done"
               
               rightButton.setTitle(pickString, for: .normal)
               rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
               rightButton.addTarget(target, action: action, for: .touchUpInside)
               
               if #available(iOS 13.0, *) {
                   if (count > 0 ) {
                       let string = count > 0 ?
                           "person.crop.circle.fill.badge.checkmark" :
                           "person.crop.circle.badge.checkmark"
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
    
    static func clearSelection(_ count: Int, action: Selector, target: UIViewController) -> UIBarButtonItem {
        let leftButton: UIButton = UIButton(type: .system)
        leftButton.setTitle(String.init(format: " Clear", count), for: .normal)
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        leftButton.addTarget(target, action: action, for: .touchUpInside)
        
        if #available(iOS 13.0, *) {
            let clearImageString = count > 0 ? "trash.circle.fill" : "trash.circle"
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
}
