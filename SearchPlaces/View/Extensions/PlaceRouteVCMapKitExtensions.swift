import MapKit

// This extension adds MKMapViewDelegate functionalities to PlaceRouteViewController.
extension PlaceRouteViewController: MKMapViewDelegate {
    
    // Provides a renderer for the map view when an overlay is added.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue   // The path line color.
        renderer.lineWidth = 3                // The path line width.
        return renderer
    }
    
    // ... Other MKMapViewDelegate methods ...
    
    // MARK: - MapKit Helper Methods
    
    // Centers the map on the user's current location.
    func centerMapToUserLocation(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 5000 // Define the region radius.
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    // Adds annotations for the start and end locations on the map.
    func addStartAndEndAnnotations(_ location: CLLocation) {
        // Annotation for the start location.
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = location.coordinate
        startAnnotation.title = "Start"
        mapView.addAnnotation(startAnnotation)

        // Annotation for the end location.
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = destinationCoordinate
        endAnnotation.title = "End"
        mapView.addAnnotation(endAnnotation)
    }
    
    // Displays the route on the map and updates the info label with route details.
    func displayRouteDetails(from route: MKRoute) {
        mapView.addOverlay(route.polyline) // Adds the route overlay to the map.
        
        // Sets the map view to the bounding rectangle of the route, with the specified edge padding.
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        
        updateInfoLabel(with: route) // Updates the info label with details about the route.
    }

    // Updates the info label with the expected travel time and distance.
    private func updateInfoLabel(with route: MKRoute) {
        let expectedTravelTime = route.expectedTravelTime
        let distance = route.distance

        // Formats the travel time into a readable string.
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        let formattedDuration = formatter.string(from: expectedTravelTime)

        // Formats the distance into a readable string in kilometers.
        let formattedDistance = String(format: "%.2f km", distance / 1000)
        infoLabel.text = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
    }

    // Presents an alert to the user if the route cannot be found.
    func displayRouteErrorAlert() {
        let alert = UIAlertController(title: "Message", message: "Unable to find Route for \(searchItem)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
}
