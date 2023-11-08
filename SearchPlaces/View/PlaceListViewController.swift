import UIKit
import MapKit
import CoreLocation

class PlaceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var didFetchPlaces = false
    var searchItem = ""
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tableView: UITableView!
    var currentLocation: CLLocation?
    var placeListArray: [Dictionary<String, Any>] = []
    var didCenterMap = false
    private var viewModel = PlaceListViewViewModel()
    // Sample data
    let placeNames = Array(repeating: "Place", count: 10)
    let suburbNames = Array(repeating: "Suburb", count: 10)
    let distances = Array(repeating: "100 km", count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(searchItem) Locations"
        setUpLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocationManager()
        didFetchPlaces = false
        placeListArray = []
        setUpTableView()
        setUpMapViewNavBarHeight()
        // Center the map
        centerMapOnCurrentLocation()
        locationManager.startUpdatingLocation()
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setUpMapViewNavBarHeight() {
        // Get the height of the navigation bar and status bar
        let topBarHeight = self.view.safeAreaInsets.top
        
        // Set up the map view
        mapView = MKMapView(frame: CGRect(x: 0, y: topBarHeight, width: self.view.frame.size.width, height: tableView.frame.origin.y - topBarHeight))
        self.view.addSubview(mapView)
    }
    
    // MARK: - Table View
    
    func setUpTableView() {
        let tableViewFrame = CGRect(x: 0, y: self.view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2)
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, forRowAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "listToDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetailSegue" {
            let placeDetailViewController = segue.destination as! PlaceDetailViewController
            let indexPath = sender as! IndexPath
            let detailData = placeListArray[indexPath.row]
            
            // Configure the destination view controller with selected place details
            if let name = detailData["name"] as? String {
                placeDetailViewController.searchItem = name
            } else {
                print("Name not found")
            }
            
            // Create a PlaceDetail instance with data from the selected row
            let placeDetail = PlaceDetail(
                iconPrefix: detailData["iconPrefix"] as? String ?? "",
                iconSuffix: detailData["iconSuffix"] as? String ?? "",
                categoryName: detailData["categoryName"] as? String ?? "",
                address: detailData["address"] as? String ?? "",
                region: detailData["region"] as? String ?? "",
                distance: detailData["distance"] as? Double ?? 0.0,
                latitude: detailData["latitude"] as? Double ?? 0.0,
                longitude: detailData["longitude"] as? Double ?? 0.0
            )
            
            // Set the view model for the destination controller
            let viewModel = PlaceDetailViewModel(detail: placeDetail)
            placeDetailViewController.viewModel = viewModel
            placeDetailViewController.placeListArrayDetail = placeListArray[indexPath.row]
        }
    }
    func updateUIWithPlaces() {
        viewModel.fetchPlaces(searchItem: searchItem, currentLocation: currentLocation) { success in
            if success {
                if self.viewModel.places.isEmpty {
                    self.noPlacesAlert(searchItem: "\(self.searchItem)")
                } else {
                    let places = self.viewModel.places
                    self.placeListArray = self.viewModel.convertToArrayOfDictionaries()
                    DispatchQueue.main.async {
                        for place in places {
                            self.updateMapViewWithPlace(place: place)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
