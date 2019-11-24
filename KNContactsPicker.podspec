Pod::Spec.new do |spec|

  spec.name         = "KNContactsPicker"
  spec.version      = "0.1.0"
  spec.summary      = "KNContactsPicker is a modern, highly customisable contacts picker with search and multi-selection options."

  spec.description  = <<-DESC
  A modern, highly customisable contact picker with multi-selection options that closely resembles the behaviour of the ContactsUI's CNContactPickerViewController.
                   DESC

  spec.homepage     = "https://github.com/dragosrobertn/KNContactsPicker"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = "dragosrobertn"
  spec.social_media_url   = "http://twitter.com/dragosrobertn"

  spec.swift_version = '5.0'
  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/dragosrobertn/KNContactsPicker.git", :tag => "#{spec.version}" }

  spec.source_files  = "KNContactsPicker/*.swift", "KNContactsPicker/Extensions/*.swift"

  spec.frameworks = "Contacts", "ContactsUI"

end
