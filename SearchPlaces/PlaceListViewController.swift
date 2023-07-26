import UIKit
import MapKit
import CoreLocation
//import Kingfisher


class PlaceListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    var didFetchPlaces = false
    var searchItem = ""
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tableView: UITableView!
    var currentLocation: CLLocation?
    var placeListArray: [Dictionary<String, Any>] = []
    var didCenterMap = false
    
    // Sample data
    let placeNames = Array(repeating: "Place", count: 10)
    let suburbNames = Array(repeating: "Suburb", count: 10)
    let distances = Array(repeating: "100 km", count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(searchItem) Locations"
        print("It is in View Didload")
        // Initialize the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("It is in View Did Appear")
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        didFetchPlaces = false
        placeListArray = []
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
            if !didCenterMap {
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                mapView.showsUserLocation = true
                currentLocation = location
                addAnnotationForCurrentLocation() // Add this line
                didCenterMap = true
            }
            
            if !didFetchPlaces {
                fetchPlaces()
                didFetchPlaces = true
            }
        }
    }

    
    func addAnnotationForCurrentLocation() {
        guard let currentLocation = currentLocation else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation.coordinate
        annotation.title = "Current Location"
        //mapView.removeAnnotations(mapView.annotations) // Remove all annotations
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotationForPlace(placeDict: [String: Any]) {
            guard let latitude = placeDict["latitude"] as? CLLocationDegrees,
                let longitude = placeDict["longitude"] as? CLLocationDegrees else {
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placeDict["name"] as? String
            mapView.addAnnotation(annotation)
        }
    
    func regionForAnnotations() -> MKCoordinateRegion? {
        guard !mapView.annotations.isEmpty else { return nil }

        var minLat: Double = 90.0, maxLat: Double = -90.0
        var minLon: Double = 180.0, maxLon: Double = -180.0

        for annotation in mapView.annotations {
            let lat = annotation.coordinate.latitude
            let lon = annotation.coordinate.longitude
            minLat = min(minLat, lat)
            maxLat = max(maxLat, lat)
            minLon = min(minLon, lon)
            maxLon = max(maxLon, lon)
        }

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)
        return MKCoordinateRegion(center: center, span: span)
    }


    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return placeNames.count
        return placeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let placeInfo = placeListArray[indexPath.row]

        let imageSize: CGFloat = 30
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeIcon")
        //imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
  
        let label1 = UILabel()
        label1.text = "\(indexPath.row + 1)"
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
        

        let label2 = UILabel()
        label2.text = placeInfo["name"] as? String ?? "N/A"
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

        let label3 = UILabel()
        label3.text = placeInfo["address"] as? String ?? "N/A"
        label3.textAlignment = .center
        label3.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

        let label4 = UILabel()
        if let distance = placeInfo["distance"] as? Double {
            label4.text = String(format: "%.1f km", distance/1000)
        } else {
            label4.text = "N/A"
        }
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
            if let name = placeListArray[indexPath.row]["name"] as? String {
                placeDetailViewController.searchItem = name
            } else {
                print("Name not found")
            }
            print(placeListArray[indexPath.row])
            placeDetailViewController.placeListArrayDetail = placeListArray[indexPath.row]
        }
    }
    
    
    func fetchPlaces() {
        print("it is in fetch places")
        
        let headers = [
            "accept": "application/json",
            "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
        ]

        let limit = 11
        let offset = 0
        let latitude = currentLocation?.coordinate.latitude ?? 0
        let longitude = currentLocation?.coordinate.longitude ?? 0

        let urlString = "https://api.foursquare.com/v3/places/search?query=\(searchItem.replacingOccurrences(of: " ", with: ""))&limit=\(limit)&offset=\(offset)&ll=\(latitude),\(longitude)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let results = json["results"] as? [[String: Any]] {
                        
                        //for (index, result) in results.enumerated() {
                        for result in results {
                        var placeDict = [String: Any]()
                            
                            if let categories = result["categories"] as? [NSDictionary],
                               let firstCategory = categories.first {
                                placeDict["iconPrefix"] = firstCategory.value(forKeyPath: "icon.prefix")
                                placeDict["iconSuffix"] = firstCategory.value(forKeyPath: "icon.suffix")
                                placeDict["categoryName"] = firstCategory["name"]
                            }

                            placeDict["distance"] = result["distance"]
                            placeDict["fsqId"] = result["fsq_id"]
                            
                            if let geocodes = result["geocodes"] as? NSDictionary,
                               let main = geocodes["main"] as? NSDictionary {
                                placeDict["latitude"] = main["latitude"]
                                placeDict["longitude"] = main["longitude"]
                            }

                            if let location = result["location"] as? NSDictionary {
                                placeDict["address"] = location["address"]
                                placeDict["postcode"] = location["postcode"]
                                placeDict["region"] = location["region"]
                            }

                            placeDict["name"] = result["name"]

                            self.placeListArray.append(placeDict)
                            //
                            self.addAnnotationForPlace(placeDict: placeDict) // Modify this line
                            if let region = self.regionForAnnotations() {
                                            DispatchQueue.main.async {
                                                self.mapView.setRegion(region, animated: true)
                                            }
                                        }
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.placeListArray.isEmpty {
                            let alert = UIAlertController(title: "Alert", message: "No Places found for \(self.searchItem)", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                                self.present(alert, animated: true)
                                            }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })

        dataTask.resume()
    }

}
