//
//  KNContactsAuthorisation.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//
import UIKit
import Contacts

public enum KNContactFetchingError: Error {
    // When access was already requested but denied
    case insufficientAccess
    
    // When user was just asked for access but they denied
    case accessNotGranted
    
    // The authorisation status is unknown
    case unknownAuthorisation
    
    // Waiting for user actions
    case pendingAuthorisation
    
    // The fetching
    case fetchRequestFailed
    
    //
    case userCancelled
}

class KNContactsAuthorisation {
    static let contactStore = CNContactStore()
    
    static func requestAccess(conditionToEnableContact: @escaping KNContactEnablingPredicate) -> Result<[CNContact], KNContactFetchingError> {
       
        
        var result: Result<[CNContact], KNContactFetchingError> = Result.failure(.pendingAuthorisation)
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            return Result.failure(.insufficientAccess)
            
        case CNAuthorizationStatus.notDetermined:
            
            contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) -> Void in
                result = granted ? self.requestAccess(conditionToEnableContact: conditionToEnableContact) : Result.failure(.accessNotGranted)
            })
            
            return result
            
            
            
        case  CNAuthorizationStatus.authorized:

            var allContacts = [CNContact]()
            let fetchRequestKeys = CNContactFetchRequest(keysToFetch: KNContactUtils.getBasicDisplayKeys())
            
            do {
                try self.contactStore.enumerateContacts(with: fetchRequestKeys, usingBlock: { (contact, stop) -> Void in
//                    allContacts.append(contact)
                    if conditionToEnableContact(contact) {
                        allContacts.append(contact)
                    }
                })
              
                return Result.success(allContacts)
            }

            catch {
                return Result.failure(.fetchRequestFailed)
            }
            
        @unknown default:
            return Result.failure(.unknownAuthorisation)
        }
        
    }
    
    static func checkAuthorisationStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
}
