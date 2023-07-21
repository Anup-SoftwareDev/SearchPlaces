

import UIKit

class CustomSearchBar: UISearchBar {

    var preferredHeight: CGFloat = 44.0 // set default height

    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: preferredHeight)
    }
}

