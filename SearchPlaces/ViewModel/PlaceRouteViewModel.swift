import UIKit
import MapKit
import CoreLocation

// ViewModel class to handle routing logic and information presentation.
class PlaceRouteViewModel {
    // A `PlaceRoute` object containing information about the destination.
    let place: PlaceRoute
    // A string to hold formatted route information for display.
    var infoText: String?

    // Initialize the ViewModel with a `PlaceRoute` object.
    init(place: PlaceRoute) {
        self.place = place
    }

    // Function to fetch route details from the current location to the `place` location.
    func fetchRouteDetails(from location: CLLocation, completion: @escaping (MKRoute?, Error?) -> Void) {
        // Creating a 2D coordinate for the destination from the `place` object.
        let destinationCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)

        // Setting up a request for turn-by-turn directions.
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = false  // Opting out of receiving alternate routes.
        request.transportType = .automobile      // Assuming travel by car.

        // Create a directions object to calculate the route.
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                // If there's an error, pass the error to the completion handler.
                completion(nil, error)
                return
            }

            // If no route is found, create a custom error and pass it to the completion handler.
            guard let route = response?.routes.first else {
                let noRouteError = NSError(domain: "com.example.routeError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No route found."])
                completion(nil, noRouteError)
                return
            }

            // Upon finding a valid route, format and store the route details in `infoText`.
            self?.setInfoText(from: route)

            // Return the route to the caller via the completion handler.
            completion(route, nil)
        }
    }

    // Private helper function to set the `infoText` property with details from an `MKRoute` object.
    private func setInfoText(from route: MKRoute) {
        // Extract the expected travel time and distance from the route.
        let expectedTravelTime = route.expectedTravelTime
        let distance = route.distance

        // Format the duration and distance for a more human-readable string.
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        let formattedDuration = formatter.string(from: expectedTravelTime)
        let formattedDistance = String(format: "%.2f km", distance / 1000)

        // Set the `infoText` to a formatted string containing the distance and time.
        infoText = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
    }
}
