import UIKit

// MARK: - Search Bar Configuration
extension ViewController {
    
    /// Sets up the search bar with the appropriate UI configurations.
    func setupSearchBar() {
        // Assign the delegate to self to receive search bar events.
        searchBar.delegate = self
        
        // Set the search bar appearance to a minimal style.
        searchBar.searchBarStyle = .minimal
        
        // Set a placeholder text in the search bar.
        searchBar.placeholder = "Search"
        
        // Set the search text field background color to white.
        searchBar.searchTextField.backgroundColor = .white
        
        // If the device is an iPad, adjust the search text field height.
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    /// Adjusts the search bar when used on an iPad.
    func searchBarAdjustForIpad() {
        // If the device is an iPad, adjust the search text field height.
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
}
