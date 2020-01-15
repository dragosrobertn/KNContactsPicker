# KNContactsPicker
![CocoaPods](https://img.shields.io/cocoapods/v/KNContactsPicker) [![codebeat badge](https://codebeat.co/badges/aaf07a97-7f1b-4c91-9966-2dcbbfb34ae5)](https://codebeat.co/projects/github-com-dragosrobertn-kncontactspicker-master) ![contributions](https://img.shields.io/badge/contributions-welcome-informational.svg)

A modern, highly customisable contact picker with multi-selection options that closely resembles the behaviour of the ContactsUI's CNContactPickerViewController.

# Preview
|![Single Deselect Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/SingleDeselectMode.gif)|![Single Reselect Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/SingleReselectMode.gif)|![Multiple Select Mode](https://github.com/dragosrobertn/KNContactsPicker/blob/master/PreviewGIFs/MultiSelectionMode.gif)|
|---|---|---|
|Single Deselect|Single Reselect|Multi Select|

# Installation

## CocoaPods
Add this to your podfile for the latest version
```
pod 'KNContactsPicker'
```
Or specify desired version
```
pod 'KNContactsPicker', '~> 0.1'
```


## Manual Installation
Download and include the `KNContactsPicker` folder and files in your codebase.

## Requirements
 - iOS 12+
 - Swift 5
 
# Features
KNContactsPicker is a modern, customisable and easy to use Contacts Picker similar to the stock CNContactPickerViewController. It does improve in a couple of area for a better UX.

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
- Extra contact info under name
- Contact sort order
- Contact display order
- More modular contact property approach

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

settings.conditionToDisplayContact = { contact in
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
You can use KNContactsPicker with [KNContacts](https://github.com/dragosrobertn/KNContacts) framework.
