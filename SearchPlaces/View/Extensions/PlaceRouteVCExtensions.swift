import UIKit

// This extension of PlaceRouteViewController is focused on setting up UI elements.
extension PlaceRouteViewController {
    
    // Sets the navigation title to reflect the current search item's route.
    func setTitle() {
        self.title = "\(searchItem) Route"
    }

    // Configures the appearance and layout of the information label.
    func setupInfoLabel() {
        infoLabel.textAlignment = .center // Align text to the center
        
        // Adjusts the font size based on the device's user interface idiom.
        infoLabel.font = UIDevice.current.userInterfaceIdiom == .pad ? UIFont.systemFont(ofSize: 30) : UIFont.systemFont(ofSize: 17)
        
        infoLabel.textColor = UIColor.white // Set the text color to white
        infoLabel.backgroundColor = UIColor.gray // Set the background color to gray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask
        self.view.addSubview(infoLabel) // Add the label to the view hierarchy
    }
    
    // Sets up auto-layout constraints for UI components within the view.
    func setupAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            // Position the infoLabel at the top of the safe area, spanning the view's width.
            infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40), // Set the height of the infoLabel

            // Position the mapView below the infoLabel, covering the rest of the screen.
            mapView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

}




