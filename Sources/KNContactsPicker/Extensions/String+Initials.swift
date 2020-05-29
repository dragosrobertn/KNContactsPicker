//
//  String+Initials.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 28/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

extension String {
    
    var initials: String {
        var finalString = String()
        var words = components(separatedBy: .whitespacesAndNewlines)
        
        if let firstCharacter = words.first?.first {
            finalString.append(String(firstCharacter))
            words.removeFirst()
        }
        
        if let lastCharacter = words.last?.first {
            finalString.append(String(lastCharacter))
        }
        
        return finalString.uppercased()
    }
}
