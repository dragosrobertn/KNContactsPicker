//
//  KNPickerSettings.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 29/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

public enum KNContactsPickerMode {
    case single
    case multiple
}

public struct KNPickerSettings {
    
    public var pickerTitle: String = "Contacts"
    public var searchBarPlaceholder: String = "Search contacts"
    
    public var pickerSelectionMode: KNContactsPickerMode = .single
    
    public init() {}
    
}
