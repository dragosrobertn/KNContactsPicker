//
//  KNPickerSettings.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 29/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation
import UIKit

public enum KNContactsPickerMode {
    case singleDeselectOthers
    case singleReselect
    case multiple
}

public enum KNContactSubtitleInfo {
    case none
    case phoneNumber
    case emailAddress
    case company
}

public struct KNPickerSettings {
    
    // MARK: PICKER TOP SETTINGS
    public var pickerTitle: String = "Contacts"
    
    public var conditionToEnableContact: KNContactEnablingPredicate = { _ in true }
    public var conditionToDisableContact: KNContactDisablingPredicate = { _ in false }
    
    // Enum value whether the contact picker should allow selecting multiple
    // or a single contact
    public var selectionMode: KNContactsPickerMode = .singleDeselectOthers
    
    // Boolean whether picker should immediately return the first contact picked
    // when the picker selectionMode is .single
    public var immediatelyReturnAfterSingleSelection: Bool = false
    
    // The pick button title to display when no contacts have been selected
    public var defaultPickButtonTitle: String = "Done"
    // The pick button title to display when contacts have been selected.
    // You may specify a string formatting for one number representing the number of selected contacts.
    public var selectedContactsPickButtonTitle: String = "Select %d"
    
    // Boolean value whether to show number of selected contacts
    public var showSelectionCountInPickButton: Bool = true
    
    
    // The clear selection button
    public var clearSelectionButtonTitle: String = " Clear"
    
    
    // MARK: SEARCH SETTINGS
    
    // The placeholder text to display in the search bar
    public var searchBarPlaceholder: String = "Search contacts"
    // The text to display when search results are shown
    public var searchResultSectionTitle: String = "Top name matches"
    
    // MARK: PULL TO DIMISS ALERT
    
    // The Pull to dimiss alert title
    public var pullToDismissAlertTitle: String = "Dismiss confirmation"
    // Message to return selection with the selected contacts when
    // pull to dismiss alert is shown
    // Contact name can be provided
    public var pullToDismissMessageSingleContact: String = "You have selected %@. What do you want to do?"
    // First contact name and number of rest of selections.
    public var pullToDismissMessageMultipleContacts: String = "You have selected %@ and %d other contacts. What do you want to do?"
    public var pullToDismissCompleteSelectionButtonTitle: String = "Pick selected contacts"
    // Message to discard selection and return no contacts when
    // pull to dimiss alert is shown
    public var pullToDismissDiscardSelectionButtonTitle: String = "Discard"
    // Cancel pull to dismiss alert text
    public var pullToDismissCancelButtonTitle: String = "Cancel"
    
    // MARK: CONTACT DISPLAY
    // Enum value for the subtitle information to be displayed
    public var subtitleDisplayInfo: KNContactSubtitleInfo = .none
    
    public init() {}
}
