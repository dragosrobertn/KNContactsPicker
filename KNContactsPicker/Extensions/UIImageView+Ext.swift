//
//  UIImageView+Ext.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 28/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    var shouldScale: Bool {
        if (self.contentMode == .scaleToFill ||
            self.contentMode == .scaleAspectFill ||
            self.contentMode == .scaleAspectFit ||
            self.contentMode == .redraw) {
            
            return true
        }
        
        return false
    }
}
