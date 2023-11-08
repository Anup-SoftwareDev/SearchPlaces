import UIKit
import MapKit
import CoreLocation

extension PlaceListViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate Methods
    
    // Called when the location manager updates the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mapView = mapView else { return }
        
        if let location = locations.first {
            // Center the map on the user's current location once
            if !didCenterMap {
                centerMapOnLocation(location)
                didCenterMap = true
            }
            
            // Fetch places only once after getting the current location
            if !didFetchPlaces {
                updateUIWithPlaces()
                didFetchPlaces = true
            }
        }
    }
    
    // Centers the map on a given CLLocation
    func centerMapOnLocation(_ location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        currentLocation = location
        addAnnotationForCurrentLocation()
    }

    // Centers the map on the location manager's current location
    func centerMapOnCurrentLocation() {
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location)
    }

    // Adds an annotation for the current location to the map view
    func addAnnotationForCurrentLocation() {
        guard let currentLocation = currentLocation else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation.coordinate
        annotation.title = "Current Location"
        mapView.addAnnotation(annotation)
    }
    
    // Adds an annotation for a given place to the map view
    func addAnnotationForPlace(place: Place) {
        // Safely unwrap the optional latitude and longitude values
        guard let latitude = place.latitude, let longitude = place.longitude else {
            print("Latitude and/or longitude are nil")
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)
    }


    // Determines the region that fits all the annotations on the map
    func regionForAnnotations() -> MKCoordinateRegion? {
        guard !mapView.annotations.isEmpty else { return nil }

        var minLat: Double = 90.0, maxLat: Double = -90.0
        var minLon: Double = 180.0, maxLon: Double = -180.0

        for annotation in mapView.annotations {
            minLat = min(minLat, annotation.coordinate.latitude)
            maxLat = max(maxLat, annotation.coordinate.latitude)
            minLon = min(minLon, annotation.coordinate.longitude)
            maxLon = max(maxLon, annotation.coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // Updates the map view with a new place by adding an annotation and adjusting the visible region
    func updateMapViewWithPlace(place: Place) {
        addAnnotationForPlace(place: place)

        if let region = regionForAnnotations() {
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}
