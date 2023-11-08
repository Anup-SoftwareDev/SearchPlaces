class HomeViewModel {
    // Callback closure that's called when `searchItem` changes.
    var searchItemDidChange: ((String) -> Void)?
    
    // Property to hold the search item text.
    var searchItem: String = "" {
        didSet {
            // Notify via the callback when `searchItem` changes.
            searchItemDidChange?(searchItem)
        }
    }
    
    // Method to update the search item.
    func updateSearchItem(with text: String) {
        searchItem = text
    }
    
    // Method to handle the search action when the search button is clicked.
    func searchBarSearchButtonClicked() {
        // Logic after the search button is clicked can be added here.
        // Currently, it only prints the search item to the console.
        print("Search Clicked: \(searchItem)")
    }
}
