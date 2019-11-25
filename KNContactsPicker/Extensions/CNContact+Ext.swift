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
    func getImageOrInitials(bounds: CGRect, scaled: Bool, gradient: GradientColors) -> UIImage? {
        guard self.imageDataAvailable, let image = self.getImage()
        else {
            return self.imageWithGradient(gradient: gradient, bounds: bounds, scaled: scaled)
        }
        return image
    }
    
    private func imageWithGradient(gradient: GradientColors, bounds: CGRect, scaled: Bool) -> UIImage? {
        let formatter = CNContactFormatter()
        let name = formatter.string(from: self)
        return UIImage.createWithGradientFromText(text: name?.initials ?? "",
                                                  gradient: gradient,
                                                  circular: true,
                                                  bounds: bounds,
                                                  shouldScale: scaled)
    }
    
    func getImage() -> UIImage? {
        guard let contactImageData = self.imageData else { return nil }
        return UIImage(data: contactImageData, scale: 1.0)
    }
    
    func getFullName(using formatter: CNContactFormatter) -> String {
        return formatter.string(from: self) ?? ""
    }
}

