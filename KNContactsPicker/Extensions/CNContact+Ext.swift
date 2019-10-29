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
            let gradientColors = GradientColors(
                top: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
                bottom: #colorLiteral(red: 0, green: 0.4881725907, blue: 1, alpha: 1)
            )
            

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
    
    func getFullName(using formatter: CNContactFormatter) -> String {
        return formatter.string(from: self) ?? ""
    }
}

