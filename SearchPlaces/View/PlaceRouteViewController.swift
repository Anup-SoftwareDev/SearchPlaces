import UIKit
import MapKit
import CoreLocation

// The PlaceRouteViewController is responsible for managing the route display on a map.
class PlaceRouteViewController: UIViewController, CLLocationManagerDelegate {
    var viewModel: PlaceRouteViewModel!
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let infoLabel = UILabel()
    var searchItem: String = ""
    
    // Location coordinates as string which will be converted to Double and used.
    var latitudeStr = "-37.65048567021611"
    var longitudeStr = "145.07059673810062"
    
    // Variable to hold the destination coordinate once the latitude and longitude strings are converted.
    var destinationCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the UI and Location Manager when the view loads.
        setTitle()
        setupInfoLabel()
        setDestinationCoordinate()
        setupMapView()
        setupAutoLayoutConstraints()
        setupLocationManager()
    }
    
    // MARK: - Setup Methods
    
    // Converts latitude and longitude strings to a CLLocationCoordinate2D and sets it to destinationCoordinate.
    private func setDestinationCoordinate() {
        if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
            destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            // If conversion fails, print an error message.
            print("Error: unable to convert latitudeStr and/or longitudeStr to Double")
        }
    }
    
    // Configures the mapView properties and adds it to the view hierarchy.
    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
    }
    
    // Configures the location manager to get user's current location.
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    // Gets called when the location manager updates the current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        // Implement these methods according to your use-case:
        // centerMapToUserLocation(location)
        // addStartAndEndAnnotations(location)
        
        viewModel.fetchRouteDetails(from: location) { [weak self] (route, error) in
            if let route = route {
                self?.displayRouteDetails(from: route)
            } else {
                self?.displayRouteErrorAlert()
            }
        }
    }
    
    // Requests directions to the destination from the current location and displays them.
    private func getDirectionsToDestination(from location: CLLocation) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            if let route = response?.routes.first {
                self.displayRouteDetails(from: route)
            } else {
                self.displayRouteErrorAlert()
            }
        }
    }
    
   
}
