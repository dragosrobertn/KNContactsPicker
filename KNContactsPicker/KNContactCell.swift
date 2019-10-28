//
//  KNContactCell.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 27/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit

class KNContactCell: UITableViewCell {
    var initialColor: UIColor {
         get {
             if #available(iOS 13.0, *) {
                 return UIColor.systemBackground
             }
             return UIColor.white
         }
     }
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        let bounds = CGRect(x: 0, y: 0, width: 45, height: 45)

        img.bounds = bounds
        img.frame = CGRect(x: img.frame.origin.x,
                           y: img.frame.origin.y ,
                           width: 45,
                           height: img.frame.size.height )
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 22.5
        img.clipsToBounds = true
       return img
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameLabel)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:45).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:45).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        self.selectionStyle = .none
     }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
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
            self.accessoryType = UITableViewCell.AccessoryType.none
            self.contentView.backgroundColor = initialColor
            self.nameLabel.textColor = UIColor.black
        }
        
        self.layoutIfNeeded()
        self.layoutSubviews()
                
        // Configure the view for the selected state
    }
    
    
}
