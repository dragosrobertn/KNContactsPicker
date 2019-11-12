//
//  KNContactCell.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 27/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

class KNContactCell: UITableViewCell {
    var disabled: Bool = false
    
    var initialColor: UIColor {
         get {
             if #available(iOS 13.0, *) {
                return self.traitCollection.userInterfaceStyle == .dark ?
                    UIColor.secondarySystemBackground :
                    UIColor.systemBackground
             }
             return UIColor.white
         }
     }
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        let bounds = CGRect(x: 0, y: 0, width: 40, height: 40)

        img.bounds = bounds
        img.frame = CGRect(x: img.frame.origin.x,
                           y: img.frame.origin.y ,
                           width: 40,
                           height: img.frame.size.height )
        img.contentMode = .scaleAspectFill
         // enable autolayout
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
       return img
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameLabel)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:40).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant:40).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = CGFloat(0.8)
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        
        self.selectionStyle = .none
     }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if (!disabled) {
            super.setSelected(selected, animated: animated)
            self.setAppropriateStyle()
        }
    }
    
    func setAppropriateStyle() {
        self.isSelected ? self.setCellToSelectedStyle() : self.setCellToUnselectedStyle()
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    func setCellToSelectedStyle() {
        self.accessoryView?.backgroundColor = UIColor.systemBlue
        self.contentView.backgroundColor = UIColor.systemBlue
        self.accessoryType = UITableViewCell.AccessoryType.checkmark
        self.tintColor = UIColor.white
        self.backgroundColor = UIColor.systemBlue

        self.nameLabel.textColor = UIColor.white
    }
    
    func setCellToUnselectedStyle() {
        self.backgroundColor = initialColor
        self.accessoryView?.backgroundColor = UIColor.clear
        self.accessoryType = UITableViewCell.AccessoryType.none
        self.contentView.backgroundColor = initialColor
        if #available(iOS 13.0, *) {
           self.nameLabel.textColor = UIColor.label
        } else {
           self.nameLabel.textColor = UIColor.black
        }
    }
    
    func setDisabled(disabled: Bool) {
        self.disabled = disabled
        
        if (self.disabled) {
            self.nameLabel.textColor = UIColor.gray
            self.isUserInteractionEnabled = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previous = previousTraitCollection else { return }
        
        if traitCollection.userInterfaceStyle != previous.userInterfaceStyle {
            self.setAppropriateStyle()
        }
    }
}
