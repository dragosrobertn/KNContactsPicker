//
//  Array+Ext.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 01/11/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

extension Array where Element: Equatable {
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) {
            self.move(from: oldIndex, to: newIndex)
        }
    }
}
