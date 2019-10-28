//
//  KNContactsPicker.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 24/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import UIKit
import Contacts

open class KNContactsPicker: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var style: UITableView.Style
        if #available(iOS 13.0, *) {
            style = UITableView.Style.insetGrouped
        } else {
            style = UITableView.Style.grouped
        }
        let controller = KNContactsPickerController(style: style)
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.viewControllers.append(controller)
    }


}
