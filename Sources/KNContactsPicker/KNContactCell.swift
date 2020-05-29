//
//  KNContactCell.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 27/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

#if canImport(UIKit)
import UIKit

class KNContactCell: UITableViewCell {
    private var disabled: Bool = false
    
    private var initialColor: UIColor {
         get {
             if #available(iOS 13.0, *) {
                return self.traitCollection.userInterfaceStyle == .dark ?
                    UIColor.secondarySystemBackground :
                    UIColor.systemBackground
             }
             return UIColor.white
         }
     }
    
    private let profileImageView: UIImageView = {
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightText
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.secondaryLabel
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 0
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(profileImageView)
        self.containerView.addArrangedSubview(nameLabel)
       
        self.contentView.addSubview(containerView)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = CGFloat(0.7)
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        
        
        self.selectionStyle = .none
     }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disabled = false
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
        self.subtitleLabel.textColor = UIColor.lightText
    }
    
    func setCellToUnselectedStyle() {
        self.backgroundColor = initialColor
        self.accessoryView?.backgroundColor = UIColor.clear
        self.accessoryType = UITableViewCell.AccessoryType.none
        self.contentView.backgroundColor = initialColor
         
        self.nameLabel.textColor = UIColor.black
        self.subtitleLabel.textColor = UIColor.lightText
        if #available(iOS 13.0, *) {
           self.nameLabel.textColor = UIColor.label
           self.subtitleLabel.textColor = UIColor.secondaryLabel
        }
        
    }
    
    func setDisabled(disabled: Bool) {
        self.disabled = disabled
        
        self.isUserInteractionEnabled = !self.disabled
        
        if (self.disabled) {
            self.nameLabel.textColor = UIColor.lightGray
            if #available(iOS 13.0, *) {
                self.nameLabel.textColor = UIColor.secondaryLabel
            }
        }
        else {
            self.nameLabel.textColor = UIColor.black
            if #available(iOS 13.0, *) {
                self.nameLabel.textColor = UIColor.label
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previous = previousTraitCollection else { return }
        
        if traitCollection.userInterfaceStyle != previous.userInterfaceStyle {
            self.setAppropriateStyle()
        }
    }
    
    public func set(contactModel: KNContactCellModel) {
        self.nameLabel.text = contactModel.getName()
        self.subtitleLabel.text = contactModel.getSubtitle()
        
        let image = contactModel.getImage(with: self.profileImageView.bounds, scaled: self.profileImageView.shouldScale)
        self.profileImageView.image = image
        self.profileImageView.highlightedImage = image
        
        if !self.subtitleLabel.text!.isEmpty {
            self.containerView.addArrangedSubview(subtitleLabel)
            subtitleLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 0).isActive = true
            subtitleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
            subtitleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        }
    }
}
#endif
