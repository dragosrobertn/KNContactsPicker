# KNContactsPicker
A modern, highly customisable contact picker with multi-selection options that closely resembles the ContactsUI picker view controller.

# Preview
|![Single Deselect Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/SingleDeselectMode.gif)|![Single Reselect Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/SingleReselectMode.gif)|![Multiple Select Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/MultiSelectionMode.gif)|
|---|---|---|
|Single Deselect|Single Reselect|Multi Select|

# Installation

## CocoaPods

## Manual Installation
Download and include the `KNContactsPicker` folder and files in your codebase.

## Requirements
 - iOS 12+
 - Swift 5
 
# Features
KNContactsPicker is a modern, customisable and easy to use Contacts Picker similar to the stock ContactPickerViewController. It improves in a couple of area. 

- Three contact selection modes:
  - Single Deselect (Deselects all other contacts after first contact is selected)
  - Single Reselect (Selects another contact on tap)
  - Multi Select
- Contact images or initials
- Search contacts and ability to select while searching
- Clear selection button
- Contact section indexes to quickly navigate through the contact list
- Returns CNContact objects
- Highly customisable settings for strings and options
- Two conditional methods to enable or deselect certain contacts
- Support iOS 13 
  - Dark Mode
  - Icons (SF Symbols)
  - Pull to Dismiss

Coming soon:
- Extra contact info under
- Contact sort order
- Contact display order

Make sure your app (the host app) has provided a `Privacy - Contacts Usage Description` in your `Info.plist`. 
It's also recommended that you check that contact authorisation is granted. 

## How to use
Implement the Delegate Methods
```swift
// This is in your application
extension ViewController: KNContactPickingDelegate {
    func contactPicker(didFailPicking error: Error) {
        print(error)
    }
    func contactPicker(didCancel error: Error) {
         print(error)
    }
    func contactPicker(didSelect contact: CNContact) {
        self.contacts.append(contact)
        self.contactsTableView.reloadData()
    }
    
    func contactPicker(didSelect contacts: [CNContact]) {
        self.contacts.append(contentsOf: contacts)
        self.contactsTableView.reloadData()
    }
}
```

Customise the Settings
```swift
var settings = KNPickerSettings()
settings.pickerTitle = "Pick"

settings.conditionToEnableContact = { contact in
  return contact.organizationName == "Apple"
}
settings.conditionToDisableContact = { contact in
    return self.contacts.contains(contact)
}
```
Initialise and Present the KNContactsPicker
```swift
let controller = KNContactsPicker(delegate: self, settings: settings)
        
self.navigationController?.present(controller, animated: true, completion: nil)
```

## Recommended
You can use KNContactsPicker with KNContacts framework.
