import UIKit
import MapKit
import CoreLocation

class PlaceRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var searchItem = ""
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let destinationCoordinate = CLLocationCoordinate2D(latitude: -37.65048567021611, longitude: 145.07059673810062)
    let infoLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "\(searchItem) Route"
        
        // Setup info label
        infoLabel.textAlignment = .center
        
        infoLabel.textColor = UIColor.white  // Set label color to white
        infoLabel.backgroundColor = UIColor.gray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(infoLabel)
        
        // Setup map view
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)

        // Auto Layout
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            mapView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        // Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()

            // Center map to user's current location
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)

            // Add annotations for start and end points
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = location.coordinate
            startAnnotation.title = "Start"
            mapView.addAnnotation(startAnnotation)

            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = destinationCoordinate
            endAnnotation.title = "End"
            mapView.addAnnotation(endAnnotation)
            
            // Get directions to the destination
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }

                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    
                    // Update info label with expected travel time and distance
                    let expectedTravelTime = route.expectedTravelTime
                    let distance = route.distance
                    
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.hour, .minute]
                    formatter.unitsStyle = .short
                    let formattedDuration = formatter.string(from: expectedTravelTime)
                    
                    let formattedDistance = String(format: "%.2f km", distance / 1000)
                    self.infoLabel.text = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3

        return renderer
    }
}

//import UIKit
//import MapKit
//import CoreLocation
//
//class PlaceRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
//
//    let mapView = MKMapView()
//    let locationManager = CLLocationManager()
//    let destinationCoordinate = CLLocationCoordinate2D(latitude: -37.65048567021611, longitude: 145.07059673810062)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Setup map view
//        mapView.delegate = self
//        mapView.frame = self.view.frame
//        self.view.addSubview(mapView)
//
//        // Setup location manager
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            locationManager.stopUpdatingLocation()
//
//            // Center map to user's current location
//            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//            mapView.setRegion(region, animated: true)
//
//            // Get directions to the destination
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
//            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
//            request.requestsAlternateRoutes = false
//            request.transportType = .automobile
//
//            let directions = MKDirections(request: request)
//            directions.calculate { [unowned self] response, error in
//                guard let unwrappedResponse = response else { return }
//
//                for route in unwrappedResponse.routes {
//                    self.mapView.addOverlay(route.polyline)
//                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//                }
//            }
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.blue
//        renderer.lineWidth = 3
//
//        return renderer
//    }
//}
//
