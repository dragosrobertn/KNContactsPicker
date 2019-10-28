//
//  KNContactsAuthorisation.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//
import UIKit
import Contacts

enum ContactFetchingError: Error {
    // When access was already requested but denied
    case insufficientAccess
    // When user was just asked for access but they denied
    case accessNotGranted
    
    // The authorisation status is unknown
    case unknownAuthorisation
    
    // The fetching
    case fetchRequestFailed
}

class KNContactsAuthorisation {
    
    static func requestAccess() -> Result<[CNContact], ContactFetchingError> {
        let contactStore = CNContactStore()
        
        var result: Result<[CNContact], ContactFetchingError> = Result.failure(.fetchRequestFailed)
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            result = Result.failure(.insufficientAccess)
            
        case CNAuthorizationStatus.notDetermined:
            
            contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) -> Void in

                result = granted ? self.requestAccess() : Result.failure(.accessNotGranted)
            })
            
        case  CNAuthorizationStatus.authorized:
            //Authorization granted by user for this app.
            var contactsArray = [CNContact]()
            
            let contactFetchRequest = CNContactFetchRequest(keysToFetch: KNContactUtils.getBasicDisplayKeys())
            
            do {
                try contactStore.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                    contactsArray.append(contact)
                })
              
                result = Result.success(contactsArray)
            }

            catch {
                result = Result.failure(.fetchRequestFailed)
            }
            
        @unknown default:
            result = Result.failure(.unknownAuthorisation)
        }
        
        return result
    }
    
    static func checkAuthorisationStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
}
