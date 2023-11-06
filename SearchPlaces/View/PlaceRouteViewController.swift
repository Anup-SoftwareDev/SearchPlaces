import UIKit
import MapKit
import CoreLocation

class PlaceRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var viewModel: PlaceRouteViewModel!
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let infoLabel = UILabel()
    
    // ... existing setup code ...
    
    var latitudeStr = "-37.65048567021611"
    var longitudeStr = "145.07059673810062"
    var searchItem = ""
    var destinationCoordinate: CLLocationCoordinate2D!  // Declare your destinationCoordinate here.
            
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        setupInfoLabel()
        setDestinationCoordinate()
        setupMapView()
        setupAutoLayoutConstraints()
        setupLocationManager()
    }

    // ... existing functions ...
    
    
        private func setTitle() {
            self.title = "\(searchItem) Route"
        }
    
        private func setupInfoLabel() {
            infoLabel.textAlignment = .center
            if UIDevice.current.userInterfaceIdiom == .pad {
                infoLabel.font = UIFont.systemFont(ofSize: 30)
            } else {
                infoLabel.font = UIFont.systemFont(ofSize: 17)  // or whatever size you want for non-iPad devices
            }
    
            infoLabel.textColor = UIColor.white
            infoLabel.backgroundColor = UIColor.gray
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(infoLabel)
        }
    
        private func setDestinationCoordinate() {
            if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                // Handle the case where latitudeStr or longitudeStr cannot be converted to Double
                print("Error: unable to convert latitudeStr and/or longitudeStr to Double")
            }
        }
    
        private func setupMapView() {
            mapView.delegate = self
            mapView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(mapView)
        }
    
        private func setupAutoLayoutConstraints() {
            NSLayoutConstraint.activate([
                infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                infoLabel.heightAnchor.constraint(equalToConstant: 40),
    
                mapView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
                mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    
        //Location Manager Code
    
        private func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()

        centerMapToUserLocation(location)
        addStartAndEndAnnotations(location)
        viewModel.fetchRouteDetails(from: location) { [weak self] (route, error) in
            if let route = route {
                self?.displayRouteDetails(from: route)
            } else {
                self?.displayRouteErrorAlert()
            }
        }
    }

    // ... remaining functions ...
    
    
        private func centerMapToUserLocation(_ location: CLLocation) {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    
        private func addStartAndEndAnnotations(_ location: CLLocation) {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = location.coordinate
            startAnnotation.title = "Start"
            mapView.addAnnotation(startAnnotation)
    
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = destinationCoordinate
            endAnnotation.title = "End"
            mapView.addAnnotation(endAnnotation)
        }
    private func getDirectionsToDestination(from location: CLLocation) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            if let route = response?.routes.first {
                displayRouteDetails(from: route)
            } else {
                displayRouteErrorAlert()
            }
        }
    }

    
        private func displayRouteDetails(from route: MKRoute) {
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            updateInfoLabel(with: route)
        }

        private func updateInfoLabel(with route: MKRoute) {
            let expectedTravelTime = route.expectedTravelTime
            let distance = route.distance
    
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .short
            let formattedDuration = formatter.string(from: expectedTravelTime)
    
            let formattedDistance = String(format: "%.2f km", distance / 1000)
            infoLabel.text = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
        }
    
        private func displayRouteErrorAlert() {
            let alert = UIAlertController(title: "Message", message: "Unable to find Route for \(searchItem)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    
    
    
    
    
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
    }

//class PlaceRouteViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
//
//
//    var latitudeStr = "-37.65048567021611"
//        var longitudeStr = "145.07059673810062"
//        var searchItem = ""
//        let mapView = MKMapView()
//        let locationManager = CLLocationManager()
//        var destinationCoordinate: CLLocationCoordinate2D!  // Declare your destinationCoordinate here.
//        let infoLabel = UILabel()
//
//    //ViewDidload code
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setTitle()
//        setupInfoLabel()
//        setDestinationCoordinate()
//        setupMapView()
//        setupAutoLayoutConstraints()
//        setupLocationManager()
//    }
//
//    private func setTitle() {
//        self.title = "\(searchItem) Route"
//    }
//
//    private func setupInfoLabel() {
//        infoLabel.textAlignment = .center
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            infoLabel.font = UIFont.systemFont(ofSize: 30)
//        } else {
//            infoLabel.font = UIFont.systemFont(ofSize: 17)  // or whatever size you want for non-iPad devices
//        }
//
//        infoLabel.textColor = UIColor.white
//        infoLabel.backgroundColor = UIColor.gray
//        infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(infoLabel)
//    }
//
//    private func setDestinationCoordinate() {
//        if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
//            destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        } else {
//            // Handle the case where latitudeStr or longitudeStr cannot be converted to Double
//            print("Error: unable to convert latitudeStr and/or longitudeStr to Double")
//        }
//    }
//
//    private func setupMapView() {
//        mapView.delegate = self
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(mapView)
//    }
//
//    private func setupAutoLayoutConstraints() {
//        NSLayoutConstraint.activate([
//            infoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            infoLabel.heightAnchor.constraint(equalToConstant: 40),
//
//            mapView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
//            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//    }
//
//    //Location Manager Code
//
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        locationManager.stopUpdatingLocation()
//
//        centerMapToUserLocation(location)
//        addStartAndEndAnnotations(location)
//        getDirectionsToDestination(from: location)
//    }
//
//    private func centerMapToUserLocation(_ location: CLLocation) {
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
//        mapView.setRegion(region, animated: true)
//    }
//
//    private func addStartAndEndAnnotations(_ location: CLLocation) {
//        let startAnnotation = MKPointAnnotation()
//        startAnnotation.coordinate = location.coordinate
//        startAnnotation.title = "Start"
//        mapView.addAnnotation(startAnnotation)
//
//        let endAnnotation = MKPointAnnotation()
//        endAnnotation.coordinate = destinationCoordinate
//        endAnnotation.title = "End"
//        mapView.addAnnotation(endAnnotation)
//    }
//
//    private func getDirectionsToDestination(from location: CLLocation) {
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
//        request.requestsAlternateRoutes = false
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//        directions.calculate { [unowned self] response, error in
//            if let unwrappedResponse = response {
//                displayRouteDetails(from: unwrappedResponse)
//            } else {
//                displayRouteErrorAlert()
//            }
//        }
//    }
//
//    private func displayRouteDetails(from response: MKDirections.Response) {
//        for route in response.routes {
//            mapView.addOverlay(route.polyline)
//            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
//            updateInfoLabel(with: route)
//        }
//    }
//
//    private func updateInfoLabel(with route: MKRoute) {
//        let expectedTravelTime = route.expectedTravelTime
//        let distance = route.distance
//
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute]
//        formatter.unitsStyle = .short
//        let formattedDuration = formatter.string(from: expectedTravelTime)
//
//        let formattedDistance = String(format: "%.2f km", distance / 1000)
//        infoLabel.text = "Distance: \(formattedDistance), Time: \(formattedDuration ?? "")"
//    }
//
//    private func displayRouteErrorAlert() {
//        let alert = UIAlertController(title: "Message", message: "Unable to find Route for \(searchItem)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default))
//        present(alert, animated: true)
//    }
//
//
//
//
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.blue
//        renderer.lineWidth = 3
//        return renderer
//    }
//}

