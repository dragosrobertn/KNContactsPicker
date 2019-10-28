//
//  ContactsUtils.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 20/12/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts

struct KNContactUtils {
    
    static func getContactsKeyDescriptors() -> [CNKeyDescriptor] {
        var array = self.getAllContactsKeys() as [CNKeyDescriptor]
        array.append(CNContactFormatter.descriptorForRequiredKeys(for: .fullName))
        return array
    }
    
    static func getBasicDisplayKeys() -> [CNKeyDescriptor] {
        var array = [
            CNContactIdentifierKey,
            CNContactFamilyNameKey,
            CNContactGivenNameKey,
            CNContactImageDataAvailableKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey
        ] as [CNKeyDescriptor]
        array.append(CNContactFormatter.descriptorForRequiredKeys(for: .fullName))
        return array
    }
    
    static func getAllContactsKeys() -> [String] {
        return [
//                CNContactNoteKey,
                CNContactTypeKey,
                CNContactDatesKey,
                CNContactUrlAddressesKey,
                CNContainerTypeKey,
                CNContainerNameKey,
                CNContainerIdentifierKey,
                CNContactRelationsKey,
                CNContactSocialProfilesKey,
                CNContactPhoneticOrganizationNameKey,
                CNContactInstantMessageAddressesKey,
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactPreviousFamilyNameKey,
                CNContactPostalAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactNameSuffixKey,
                CNContactNicknameKey,
                CNContactOrganizationNameKey,
                CNContactDepartmentNameKey,
                CNContactJobTitleKey,
                CNContactPhoneticGivenNameKey,
                CNContactPhoneticFamilyNameKey,
                CNContactPhoneticMiddleNameKey,
                CNContactImageDataAvailableKey,
                CNContactImageDataKey,
                CNContactThumbnailImageDataKey,
                CNContactEmailAddressesKey,
                CNContactBirthdayKey,
                CNContactNonGregorianBirthdayKey
        ]
    }
}
