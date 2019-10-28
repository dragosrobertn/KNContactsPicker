//
//  CNContact+Ext.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 22/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

extension CNContact {
    func getImageOrInitials(bounds: CGRect, scaled: Bool) -> UIImage? {
        guard self.imageDataAvailable, let image = self.getImage()
        else {
            let gradientColors = GradientColors(top: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), bottom: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))

            let formatter = CNContactFormatter()
            let name = formatter.string(from: self)
            return UIImage.createWithGradientFromText(text: name?.initials ?? "",
                                                                   gradient: gradientColors,
                                                                   circular: true,
                                                                   bounds: bounds,
                                                                   shouldScale: scaled)
        }
        return image
    }
    
    func getImage() -> UIImage? {
        guard let contactImageData = self.imageData else { return nil }
        return UIImage(data: contactImageData, scale: 1.0)
    }
}

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
