//
//  PlaceRouteViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 6/11/2023.
//

import UIKit
import MapKit
import CoreLocation

class PlaceRouteViewModel {
    let place: PlaceRoute
    var infoText: String?

    init(place: PlaceRoute) {
        self.place = place
    }

    func fetchRouteDetails(from location: CLLocation, completion: @escaping (MKRoute?, Error?) -> Void) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let route = response?.routes.first else {
                let noRouteError = NSError(domain: "com.example.routeError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No route found."])
                completion(nil, noRouteError)
                return
            }

            // If we have a valid route, set the infoText based on the route details
            self?.setInfoText(from: route)

            // Return the route through the completion handler
            completion(route, nil)
        }
    }

    private func setInfoText(from route: MKRoute) {
        let expectedTravelTime = route.expectedTravelTime
        let distance = route.distance

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        let formattedDuration = formatter.string(from: expectedTravelTime)
        let formattedDistance = String(format: "%.2f km", distance / 1000)

        infoText = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
    }

}
