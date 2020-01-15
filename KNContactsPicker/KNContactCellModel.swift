//
//  KNContactCellModel.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 14/01/2020.
//  Copyright © 2020 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import UIKit

struct KNContactCellModel {
    private var contact: CNContact
    private var settings: KNPickerSettings
    private var formatter: CNContactFormatter
    
    init(contact: CNContact, settings: KNPickerSettings, formatter: CNContactFormatter) {
        self.contact = contact
        self.settings = settings
        self.formatter = formatter
    }
    
    func getName() -> String {
        return contact.getFullName(using: formatter)
    }
    
    func getImage(with bounds: CGRect, scaled: Bool) -> UIImage? {
        let initialsBgColors = settings.contactInitialsBackgroundColor
        let userProvidedImage = settings.contactCellUserProvidedImage
        let order = settings.contactCellImageOptionOrder
        
        var image: UIImage?
        for item in order {
            if image == nil {
                if item == .contactImage {
                    image = contact.getImage()
                }
                if item == .initials {
                    image = contact.imageWithGradient(gradient: initialsBgColors, bounds: bounds, scaled: scaled)
                }
                if item == .userProvidedImage {
                    image = userProvidedImage
                }
            } else {
                break
            }
        }
        
        return image
        
    }
    
    func getSubtitle() -> String {
        let subtitleOption = settings.subtitleDisplayInfo
        switch subtitleOption {
        case .none:
            return ""
        case .organizationName:
            return contact.organizationName
        case .phoneNumber:
            return getFirstPhoneNumber()
        case .emailAddress:
            return getFirstEmailAddress()
        }
    }
    
    private func getFirstPhoneNumber() -> String {
        return self.contact.phoneNumbers.compactMap { String($0.value.stringValue) }.first ?? ""
    }
    
    private func getFirstEmailAddress() -> String {
         return self.contact.emailAddresses.compactMap { String($0.value) }.first ?? ""
    }
    
}
