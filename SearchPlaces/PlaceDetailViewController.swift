

import UIKit

class PlaceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailView: UIImageView!
    var searchItem = ""
    //var placeListArrayDetail: [Dictionary<String, Any>] = []
    var placeListArrayDetail: [String: Any] = [:]
    let imageView = UIImageView()
    let tableView = UITableView()
    let routeButton = UIButton()
    let photosButton = UIButton()
  
    var cellData: [(String, String)] = []


//    var cellData = [
//        ("Category:", "Grocery Store"),
//        ("Address:", "12 Long Street, Long Town, 3456"),
//        ("Locality:", "Long Town"),
//        ("PostCode:", "3456"),
//        ("Region:", "QLD"),
//        ("Distance","10km"),
//        ("Latitude","-37.630654"),
//        ("Longitude","145.0820098803975")
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(searchItem) Details"
        
        // Set up ImageView
        let prefix = placeListArrayDetail["iconPrefix"] as? String ?? "N/A"
        let suffix = placeListArrayDetail["iconSuffix"] as? String ?? "N/A"
       

         let iconURL = URL(string: prefix + "100" + suffix)
         if let imageURL = iconURL {
             DispatchQueue.global().async {
                 let data = try? Data(contentsOf: imageURL)
                 if let data = data {
                     let image = UIImage(data: data)
                     DispatchQueue.main.async {
                         self.imageView.image = image
                     }
                 }
             }
         }
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
       // imageView.image = UIImage(named: "listplaces")  // Replace with your icon name
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        // Set up TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        // Set up buttons
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.setTitle("Route", for: .normal)
        routeButton.backgroundColor = .gray
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        self.view.addSubview(routeButton)
        
        photosButton.translatesAutoresizingMaskIntoConstraints = false
        photosButton.setTitle("Photos", for: .normal)
        photosButton.backgroundColor = .gray
        photosButton.addTarget(self, action: #selector(photosButtonTapped), for: .touchUpInside)
        self.view.addSubview(photosButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            routeButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            routeButton.widthAnchor.constraint(equalToConstant: 150),
            routeButton.heightAnchor.constraint(equalToConstant: 40),
            routeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -2.5), // Spacing of 5 in between
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            photosButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            photosButton.widthAnchor.constraint(equalToConstant: 150),
            photosButton.heightAnchor.constraint(equalToConstant: 40),
            photosButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 2.5), // Spacing of 5 in between
            photosButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Extracting place detail data from placeListArrayDetail and populating cellData
        let categoryName = placeListArrayDetail["categoryName"] as? String ?? "N/A"
        let address = placeListArrayDetail["address"] as? String ?? "N/A"
        let region = placeListArrayDetail["region"] as? String ?? "N/A"
        let distanceMeters = placeListArrayDetail["distance"] as? Double
        let distance = distanceMeters.map { String(format: "%.1f km", $0 / 1000) } ?? "N/A" // converted to km
        let latitude = (placeListArrayDetail["latitude"] as? Double).map { "\($0)" } ?? "N/A"
        let longitude = (placeListArrayDetail["longitude"] as? Double).map { "\($0)" } ?? "N/A"

        cellData = [
            ("Category:", categoryName),
            ("Address:", address),
            ("Region:", region),
            ("Distance", distance),
            ("Latitude", latitude),
            ("Longitude", longitude)
        ]

    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let (label1Text, label2Text) = cellData[indexPath.row]
        cell.textLabel?.text = label1Text
        cell.detailTextLabel?.text = label2Text
        return cell
    }

    @objc func routeButtonTapped() {
        performSegue(withIdentifier: "detailToRoute", sender: self)
    }

    @objc func photosButtonTapped() {
        performSegue(withIdentifier: "detailToPhotos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToPhotos" {
            let placePhotoViewController = segue.destination as! PlacePhotosViewController
            placePhotoViewController.searchItem = self.searchItem
            if let fourSquareId = placeListArrayDetail["fsqId"] as? String{
                placePhotoViewController.fourSquareId = fourSquareId
            }
        }
        if segue.identifier == "detailToRoute" {
            let placeRouteViewController = segue.destination as! PlaceRouteViewController
            print("search Item before Route:\(self.searchItem)")
            placeRouteViewController.searchItem = self.searchItem
            if let latitude = placeListArrayDetail["latitude"] as? Double,
               let longitude = placeListArrayDetail["longitude"] as? Double {
                placeRouteViewController.latitudeStr = String(latitude)
                placeRouteViewController.longitudeStr = String(longitude)
            } else {
                print("Error: unable to convert latitude and/or longitude to String")
            }
        }
    }


}

