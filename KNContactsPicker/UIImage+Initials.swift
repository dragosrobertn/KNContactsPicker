//
//  UIImage+Initials.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 16/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

public typealias GradientColors = (top: UIColor, bottom: UIColor)

extension UIImage {
    
    public static func createWithBgColorFromText(text: String,
                                                 color: UIColor,
                                                 circular: Bool,
                                                 textAttributes: [NSAttributedString.Key: Any]? = nil,
                                                 bounds: CGRect,
                                                 shouldScale: Bool) -> UIImage? {
        
        return imageSnapshot(text: text, color: color, circular: circular, textAttributes: textAttributes, bounds: bounds, shouldScale: shouldScale)!
    }
    
    public static func createWithGradientFromText(text: String,
                                                  gradient: GradientColors,
                                                  circular: Bool,
                                                  textAttributes: [NSAttributedString.Key: Any]? = nil,
                                                  bounds: CGRect,
                                                  shouldScale: Bool) -> UIImage? {
        
        return imageSnapshot(text: text, gradientColors: gradient, circular: circular, textAttributes: textAttributes, bounds: bounds, shouldScale: shouldScale)
    }
    
    private static func imageSnapshot(text: String?,
                                      color: UIColor = .blue,
                                      gradientColors: GradientColors? = nil,
                                      circular: Bool,
                                      textAttributes: [NSAttributedString.Key: Any]?,
                                      bounds: CGRect,
                                      shouldScale: Bool) -> UIImage? {
        let scale = UIScreen.main.scale
        var size = bounds.size
        
        if shouldScale {
            size.width = (size.width * scale) / scale
            size.height = (size.height * scale) / scale
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPath(ellipseIn: bounds, transform: nil)
            context?.addPath(path)
            context?.clip()
        }
        
        if let gradientColors = gradientColors {
            // Draw a gradient from the top to the bottom
            let baseSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [gradientColors.top.cgColor, gradientColors.bottom.cgColor]
            let gradient = CGGradient(colorsSpace: baseSpace, colors: colors as CFArray, locations: nil)!
            
            let startPoint = CGPoint(x: bounds.midX, y: bounds.minY)
            let endPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
            
            context?.drawLinearGradient(gradient,
                                        start: startPoint,
                                        end: endPoint,
                                        options: CGGradientDrawingOptions(rawValue: 0))
        } else {
            // Fill background of context
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        // Text
        if let text = text {
            let kFontResizingProportion: CGFloat = 0.4
            let fontSize = bounds.width * kFontResizingProportion
            let attributes = textAttributes ?? [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
            
            let textSize = text.size(withAttributes: attributes)
            let bounds = bounds
            let rect = CGRect(x: bounds.size.width / 2 - textSize.width / 2, y: bounds.size.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height)
            
            text.draw(in: rect, withAttributes: attributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

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
