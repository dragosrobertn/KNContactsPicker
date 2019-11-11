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
                 return UIColor.secondarySystemFill
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
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 20
//        img.layer.borderWidth = 2
//        img.layer.borderColor = UIColor.white.cgColor
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
        nameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant:40).isActive = true
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = CGFloat(0.5)
//        nameLabel.allowsDefaultTighteningForTruncation = .
        
        
        self.selectionStyle = .none
     }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        
        if (!disabled) {
            super.setSelected(selected, animated: animated)
            if (self.isSelected) {
                self.accessoryView?.backgroundColor = UIColor.systemBlue
                self.accessoryType = UITableViewCell.AccessoryType.checkmark
                self.tintColor = UIColor.white
                self.backgroundColor = UIColor.systemBlue
                self.contentView.backgroundColor = UIColor.systemBlue
                self.nameLabel.textColor = UIColor.white
            }
            else {
                self.backgroundColor = initialColor
                self.accessoryView?.backgroundColor = UIColor.clear
                self.accessoryType = UITableViewCell.AccessoryType.none
                self.contentView.backgroundColor = initialColor
               // self.nameLabel.textColor = UIColor.black
            }

            self.layoutIfNeeded()
            self.layoutSubviews()
        }
        
        
                
    }
    
    func setDisabled(disabled: Bool) {
        self.disabled = disabled
        
        if (self.disabled) {
            self.nameLabel.textColor = UIColor.gray
            self.isUserInteractionEnabled = false
        }
    }
}
