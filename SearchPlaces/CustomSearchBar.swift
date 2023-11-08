import UIKit

// This class customizes the default UISearchBar to allow for a preferred height.
class CustomSearchBar: UISearchBar {
    
    // Set the preferred height for the search bar.
    var preferredHeight: CGFloat = 44.0 // Set default height

    // Override the intrinsicContentSize to use the preferred height.
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: preferredHeight)
    }
}


