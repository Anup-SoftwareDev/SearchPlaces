import UIKit
import MapKit
import CoreLocation

class PlaceListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var searchItem = ""
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tableView: UITableView!
    
    // Sample data
    let placeNames = Array(repeating: "Place", count: 10)
    let suburbNames = Array(repeating: "Suburb", count: 10)
    let distances = Array(repeating: "100 km", count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(searchItem) Locations"
        
        // Initialize the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize the table view
        let tableViewFrame = CGRect(x: 0, y: self.view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2)
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)

        // Get the height of the navigation bar and status bar
        let topBarHeight = self.view.safeAreaInsets.top
        
        // Initialize the map view
        mapView = MKMapView(frame: CGRect(x: 0, y: topBarHeight, width: self.view.frame.size.width, height: tableView.frame.origin.y - topBarHeight))
        self.view.addSubview(mapView)
        
        // Center the map
        centerMapOnCurrentLocation()
        
        locationManager.startUpdatingLocation()
    }




    func centerMapOnCurrentLocation() {
        guard let location = locationManager.location else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mapView = mapView else { return } // Safely unwrap mapView

        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }

    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Remove old content
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add 4 labels
        let labelWidth = cell.contentView.frame.size.width / 4
        let labelHeight = cell.contentView.frame.size.height
        let labels = (0..<4).map { (index) -> UILabel in
            let label = UILabel(frame: CGRect(x: CGFloat(index) * labelWidth, y: 0, width: labelWidth, height: labelHeight))
            label.textAlignment = .center
            return label
        }
        
        labels[0].text = "\(indexPath.row + 1)"
        labels[1].text = placeNames[indexPath.row]
        labels[2].text = suburbNames[indexPath.row]
        labels[3].text = distances[indexPath.row]
        
        labels.forEach { cell.contentView.addSubview($0) }
        
        return cell
    }
}


