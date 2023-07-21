import UIKit

class PlacePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageNames = ["homebgd", "listplaces", "globe", "listplaces", "homebgd", "globe"]  // Replace with your image names
    var collectionView: UICollectionView!
    var searchItem = ""
    var placeImages: [[String: Any]] = []
    var fourSquareId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(searchItem) Photos"
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        // calculate cell size to fit two cells with margins side by side
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)  // Keep width and height same for square cells
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false  // Remember to set this to false when using AutoLayout constraints
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.gray  // Set the background color to gray
        self.view.addSubview(collectionView)

        // Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        fetchPhotos()
        print("FourSquareId: \(fourSquareId)")
    }
    
    // MARK: - UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.placeImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView

        let imageDict = self.placeImages[indexPath.item]
        if let prefix = imageDict["prefix"] as? String,
           let suffix = imageDict["suffix"] as? String {
            let imageURLString = prefix + "200" + suffix
            if let url = URL(string: imageURLString) {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
                task.resume()
            }
        }

        return cell
    }


    func fetchPhotos() {
        print("it is in fetch photos")
        let headers = [
          "accept": "application/json",
          "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
        ]

        //let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/4be9f15561aca59357388300/photos")! as URL,
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.foursquare.com/v3/places/\(fourSquareId)/photos")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                print("Received \(data.count) bytes of data")
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                        self.placeImages = jsonArray
                        print("placeImages in fetch: \(self.placeImages)")
                        
                        // Once data is fetched, reload collectionView on the main queue
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            if self.placeImages.isEmpty {
                                let alert = UIAlertController(title: "Alert", message: "A.No Photos found for \(self.searchItem)", preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                                    self.present(alert, animated: true)
                                                }
                        }
                    } else {
                        print("Could not cast JSON to an array of [String: Any] dictionaries")
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Raw JSON string: \(String(describing: jsonString))")
                        let alert = UIAlertController(title: "Alert", message: "1.No Photos found for \(self.searchItem)", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true)
                        
                    }
                } catch let error as NSError {
                    print("JSON parsing failed: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Alert", message: "2.No Photos found for \(self.searchItem)", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true)
                }
            } else {
                print("No data and no error... something went wrong!")
                let alert = UIAlertController(title: "Alert", message: "3.No Photos found for \(self.searchItem)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alert, animated: true)
            }
        })

        dataTask.resume()

        
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if let error = error {
//                print("Error: \(error)")
//            } else if let data = data {
//                print("Received \(data.count) bytes of data")
//                do {
//                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
//                        self.placeImages = jsonArray
//                        print("placeImages in fetch: \(self.placeImages)")
//                        //print(jsonArray.count)
//                        // Now you can iterate over jsonArray to handle each individual object
//                        for json in jsonArray {
//
//                           // print("JSON Object: \(json)")
//                        }
//                    } else {
//                        print("Could not cast JSON to an array of [String: Any] dictionaries")
//                        let jsonString = String(data: data, encoding: .utf8)
//                        print("Raw JSON string: \(String(describing: jsonString))")
//                    }
//                } catch let error as NSError {
//                    print("JSON parsing failed: \(error.localizedDescription)")
//                }
//            } else {
//                print("No data and no error... something went wrong!")
//            }
//
//        })
//
//        dataTask.resume()

    }
}






