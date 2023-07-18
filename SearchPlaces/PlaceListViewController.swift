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
        self.title = "\(searchItem) Locations"
        
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
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageSize: CGFloat = 30
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homebgd")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
       

        let label1 = UILabel()
        label1.text = "\(indexPath.row + 1)"
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        

        let label2 = UILabel()
        label2.text = placeNames[indexPath.row]
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        let label3 = UILabel()
        label3.text = suburbNames[indexPath.row]
        label3.textAlignment = .center
        label3.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        //label3.layer.borderWidth = 1
        //label3.layer.borderColor = UIColor.gray.cgColor

        let label4 = UILabel()
        label4.text = distances[indexPath.row]
        label4.textAlignment = .center
        label4.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
       

        // Add subviews
        cell.contentView.addSubview(label1)
        cell.contentView.addSubview(label2)
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(label3)
        cell.contentView.addSubview(label4)

        // Apply constraints
        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label1.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label1.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.10), // 20% of the cell's width

            imageView.leadingAnchor.constraint(equalTo: label1.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),

            label2.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            label2.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label2.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.25),

            label3.leadingAnchor.constraint(equalTo: label2.trailingAnchor),
            label3.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label3.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.35),

            label4.leadingAnchor.constraint(equalTo: label3.trailingAnchor),
            label4.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            label4.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
        ])

        return cell
    }




    
    // This method gets called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after it's selected to get rid of the gray highlight.
        tableView.deselectRow(at: indexPath, animated: true)

        // Perform the segue. You can pass the indexPath if you need to know which cell was tapped.
        performSegue(withIdentifier: "listToDetailSegue", sender: indexPath)
    }

    // This method allows you to pass data to the new view controller before the segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetailSegue" {
            let placeDetailViewController = segue.destination as! PlaceDetailViewController
            let indexPath = sender as! IndexPath
            placeDetailViewController.searchItem = placeNames[indexPath.row]
        }
    }

}


