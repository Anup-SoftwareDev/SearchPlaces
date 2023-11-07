import UIKit

// MARK: - PlaceDetailViewController Extension
extension PlaceDetailViewController {
    
    // MARK: - Orientation Change
    
    /// Called when the orientation of the device changes.
    @objc func orientationChanged(_ notification: Notification) {
        updateFinalImageViewConstraints()
        updateFontSizeForVisibleCells()
        // Uncomment the line below if you need to reload the tableView on orientation change
        // tableView.reloadData()
    }
    
    // MARK: - View Layout Updates
    
    /// Called after the view has completed layout updates.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFinalImageViewConstraints()
        
        // Asynchronously update font size for visible cells after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateFontSizeForVisibleCells()
        }
    }
    
    /// Updates the image view constraints based on the current interface orientation.
    func updateFinalImageViewConstraints() {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if scene.interfaceOrientation.isPortrait {
                        self.imageViewWidthConstraint?.constant = 400
                        self.imageViewHeightConstraint?.constant = 400
                    } else {
                        self.imageViewWidthConstraint?.constant = 200
                        self.imageViewHeightConstraint?.constant = 200
                    }
                } else {
                    self.imageViewWidthConstraint?.constant = 200
                    self.imageViewHeightConstraint?.constant = 200
                }
                view.layoutIfNeeded()  // force the layout pass immediately
            }
        }
    
    // MARK: - Button Actions
    
    /// Called when the route button is tapped.
    @objc func routeButtonTapped() {
        performSegue(withIdentifier: "detailToRoute", sender: self)
    }

    /// Called when the photos button is tapped.
    @objc func photosButtonTapped() {
        performSegue(withIdentifier: "detailToPhotos", sender: self)
    }
    
    // MARK: - Navigation
    
    /// Prepares for the segue by setting up destination view controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToPhotos" {
            // Setup for PlacePhotosViewController
            if let placePhotoViewController = segue.destination as? PlacePhotosViewController {
                placePhotoViewController.viewModel.searchItem = self.searchItem
                if let fourSquareId = placeListArrayDetail["fsqId"] as? String {
                    placePhotoViewController.viewModel.fourSquareId = fourSquareId
                }
            }
        } else if segue.identifier == "detailToRoute" {
            // Setup for PlaceRouteViewController
            if let placeRouteViewController = segue.destination as? PlaceRouteViewController,
               let latitude = placeListArrayDetail["latitude"] as? Double,
               let longitude = placeListArrayDetail["longitude"] as? Double {
                
                let place = PlaceRoute(latitude: latitude, longitude: longitude, name: self.searchItem)
                placeRouteViewController.viewModel = PlaceRouteViewModel(place: place)
                
                // Print search item for debugging purposes
                print("search Item before Route: \(self.searchItem)")
                
                // Convert latitude and longitude to strings for the route view controller
                placeRouteViewController.latitudeStr = String(latitude)
                placeRouteViewController.longitudeStr = String(longitude)
            } else {
                print("Error: unable to convert latitude and/or longitude to String")
            }
        }
    }
}


