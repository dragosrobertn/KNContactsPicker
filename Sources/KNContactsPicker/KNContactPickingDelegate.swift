//
//  KNContactPickingDelegate.swift
//  KNContactsPicker
//
//  Created by Dragos-Robert Neagu on 30/10/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

#if canImport(Contacts)
import Contacts

@available(OSX 10.11, *)
public protocol KNContactPickingDelegate: AnyObject {
    func contactPicker(didFailPicking error: Error)
    func contactPicker(didCancel error: Error)
    func contactPicker(didSelect contact: CNContact)
    func contactPicker(didSelect contacts: [CNContact])
}

@available(OSX 10.11, *)
public extension KNContactPickingDelegate {
    func contactPicker(didFailPicking error: Error) { }
    func contactPicker(didCancel error: Error) { }
    func contactPicker(didSelect contact: CNContact) { }
    func contactPicker(didSelect contacts: [CNContact]) { }
}
#endif
