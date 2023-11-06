

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
    
    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewHeightConstraint: NSLayoutConstraint?
    var viewModel: PlaceDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.title = "\(searchItem) Details"
        
        // Set up ImageView
//        let prefix = placeListArrayDetail["iconPrefix"] as? String ?? "N/A"
//        let suffix = placeListArrayDetail["iconSuffix"] as? String ?? "N/A"
//
//
//         let iconURL = URL(string: prefix + "100" + suffix)
        let iconURL = viewModel.iconURL
         if let imageURL = iconURL {
             DispatchQueue.global().async {
                 let data = try? Data(contentsOf: imageURL)
                 if let data = data {
                     let image = UIImage(data: data)
                     DispatchQueue.main.async {
                         self.imageView.image = image
                         self.imageView.backgroundColor = UIColor.red


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
        
        // Set up ImageView and constraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 200)
            imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewWidthConstraint!,
            imageViewHeightConstraint!,
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
//        let categoryName = placeListArrayDetail["categoryName"] as? String ?? "N/A"
//
//        let address = placeListArrayDetail["address"] as? String ?? "N/A"
//        let region = placeListArrayDetail["region"] as? String ?? "N/A"
//        let distanceMeters = placeListArrayDetail["distance"] as? Double
//        let distance = distanceMeters.map { String(format: "%.1f km", $0 / 1000) } ?? "N/A" // converted to km
//        let latitude = (placeListArrayDetail["latitude"] as? Double).map { "\($0)" } ?? "N/A"
//        let longitude = (placeListArrayDetail["longitude"] as? Double).map { "\($0)" } ?? "N/A"
//
//        cellData = [
//            ("Category:", categoryName),
//            ("Address:", address),
//            ("Region:", region),
//            ("Distance", distance),
//            ("Latitude", latitude),
//            ("Longitude", longitude)
//        ]
        cellData = viewModel.cellData
        updateImageViewConstraints()

    }
    
    // Add this function to your class
    func updateCellFont(cell: UITableViewCell) {
        cell.textLabel?.numberOfLines = 0  // This allows the label to display an unlimited number of lines.
        cell.textLabel?.lineBreakMode = .byWordWrapping  // This wraps the text within the label.
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if scene.interfaceOrientation.isPortrait {
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
                    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 30)
                    

                   
                } else {
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
                }
            } else {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.tableView.reloadData()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    @objc func orientationChanged(_ notification: Notification) {
        updateImageViewConstraints()
        updateFontSizeForVisibleCells()
        //tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            updateImageViewConstraints()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateFontSizeForVisibleCells()
            }
        
    }
    
    // Add this function to your class
    func updateFontSizeForVisibleCells() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in visibleIndexPaths {
                if let cell = tableView.cellForRow(at: indexPath) {
                    updateCellFont(cell: cell)
                }
            }
        }
    }

    
    
    func updateImageViewConstraints() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if scene.interfaceOrientation.isPortrait {
                    self.imageViewWidthConstraint?.constant = 400
                    self.imageViewHeightConstraint?.constant = 400
                } else {
                    self.imageViewWidthConstraint?.constant = 200
                    self.imageViewHeightConstraint?.constant = 200
                }
            } else {
                self.imageViewWidthConstraint?.constant = 200
                self.imageViewHeightConstraint?.constant = 200
            }
            view.layoutIfNeeded()  // force the layout pass immediately
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let (label1Text, label2Text) = cellData[indexPath.row]
        cell.textLabel?.text = label1Text
        cell.detailTextLabel?.text = label2Text
        //updateFontSizeForVisibleCells()
        updateCellFont(cell: cell)
        
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
            placePhotoViewController.viewModel.searchItem = self.searchItem
            if let fourSquareId = placeListArrayDetail["fsqId"] as? String{
                placePhotoViewController.viewModel.fourSquareId = fourSquareId
            }
        }
        
//        if segue.identifier == "detailToRoute" {
//            let placeRouteViewController = segue.destination as! PlaceRouteViewController
//            placeRouteViewController.viewModel = PlaceRouteViewModel()
//            print("search Item before Route:\(self.searchItem)")
//            placeRouteViewController.searchItem = self.searchItem
//            if let latitude = placeListArrayDetail["latitude"] as? Double,
//               let longitude = placeListArrayDetail["longitude"] as? Double {
//                placeRouteViewController.latitudeStr = String(latitude)
//                placeRouteViewController.longitudeStr = String(longitude)
//            } else {
//                print("Error: unable to convert latitude and/or longitude to String")
//            }
//        }
        if segue.identifier == "detailToRoute" {
            let placeRouteViewController = segue.destination as! PlaceRouteViewController
            print("search Item before Route:\(self.searchItem)")
            placeRouteViewController.searchItem = self.searchItem
            
            if let latitude = placeListArrayDetail["latitude"] as? Double,
               let longitude = placeListArrayDetail["longitude"] as? Double {
                
                placeRouteViewController.latitudeStr = String(latitude)
                placeRouteViewController.longitudeStr = String(longitude)
                
                // Create a PlaceRoute object
                let place = PlaceRoute(latitude: latitude, longitude: longitude, name: self.searchItem)
                
                // Create a PlaceRouteViewModel using the PlaceRoute object
                let viewModel = PlaceRouteViewModel(place: place)
                
                // Assign the view model to the PlaceRouteViewController
                placeRouteViewController.viewModel = viewModel
            } else {
                print("Error: unable to convert latitude and/or longitude to String")
            }
        }
    }


}

