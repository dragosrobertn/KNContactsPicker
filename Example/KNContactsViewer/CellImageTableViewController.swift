//
//  CellImageTableViewController.swift
//  KNContactsViewer
//
//  Created by Dragos-Robert Neagu on 14/01/2020.
//  Copyright © 2020 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import KNContactsPicker

protocol CellImageOrderDelegate {
    func orderChanged(to cellImageOrder: [KNContactCellImageOptions])
}

class CellImageTableViewController: UITableViewController {
    
    let titleSource: [KNContactCellImageOptions: String] = [
        .contactImage : "Contact image (if available)",
        .initials : "Contact Initials",
        .userProvidedImage: "User Provided image"
    ]
    
    let imageSource: [KNContactCellImageOptions: String] = [
        .contactImage : "person.crop.circle.fill",
        .initials : "a.circle.fill",
        .userProvidedImage: "photo.fill"
    ]
    var delegate: CellImageOrderDelegate?
    var cellImageOptions: [KNContactCellImageOptions] = [.contactImage, .initials, .userProvidedImage]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.setEditing(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Order (in terms of preference)"
        } else if section == 1 {
            return "User Provided Image"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Image cannot be changed, for demo purposes only"
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellImageOptions.count
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? "cellImageOptionIdentifier" : "userProvidedImageCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if indexPath.section == 0 {
            let option = cellImageOptions[indexPath.row]
            cell.imageView?.image = UIImage(systemName: imageSource[option]!)!
            cell.textLabel?.text = titleSource[option]!
        }
        else if indexPath.section == 1 {
            cell.imageView?.image = UIImage(named: "contact-cell-image.pdf")
        }

        return cell
    }
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = self.cellImageOptions[fromIndexPath.row]
        cellImageOptions.remove(at: fromIndexPath.row)
        cellImageOptions.insert(movedObject, at: to.row)
        self.delegate?.orderChanged(to: cellImageOptions)
    }

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return indexPath.section == 0
    }

}
