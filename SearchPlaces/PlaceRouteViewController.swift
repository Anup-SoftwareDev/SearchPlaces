import UIKit
import MapKit
import CoreLocation

class PlaceRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    var latitudeStr = "-37.65048567021611"
        var longitudeStr = "145.07059673810062"
        var searchItem = ""
        let mapView = MKMapView()
        let locationManager = CLLocationManager()
        var destinationCoordinate: CLLocationCoordinate2D!  // Declare your destinationCoordinate here.
        let infoLabel = UILabel()
    
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        self.title = "\(searchItem) Route"
        
        // Setup info label
        infoLabel.textAlignment = .center
        
        if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                    destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                } else {
                    // Handle the case where latitudeStr or longitudeStr cannot be converted to Double
                    print("Error: unable to convert latitudeStr and/or longitudeStr to Double")
                    return
                }
        
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
                
                if let unwrappedResponse = response {
                    for route in unwrappedResponse.routes {
                        self.mapView.addOverlay(route.polyline)
                        //self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                        
                        
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
                }else{
                    let alert = UIAlertController(title: "Message", message: "Unable to find Route for \(self.searchItem)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true)
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

