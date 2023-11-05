import UIKit

class PlacePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var viewModel: PlacePhotosViewModel = PlacePhotosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(viewModel.searchItem) Photos"
        
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
        
        viewModel.didUpdatePhotos = { [weak self] in
            DispatchQueue.main.async {
                self?.displayFetchedPhotos()
            }
        }

        viewModel.didReceiveError = { [weak self] error in
            DispatchQueue.main.async {
                self?.ErrorMessage()
            }
        }
        
        viewModel.fetchPhotos()
        print("FourSquareId: \(viewModel.fourSquareId)")
        print("PlaceImages: \(viewModel.placeImages)")    }
    
    // MARK: - UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.placeImages.count
    }
    
    // MARK: - UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photosToPhotoDetail", sender: self.viewModel.placeImages[indexPath.item])
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        let imageDict = self.viewModel.placeImages[indexPath.item]
        let prefix = imageDict.prefix
        let suffix = imageDict.suffix
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

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosToPhotoDetail" {
            if let photoDetailViewController = segue.destination as? PhotoDetailViewController,
               //let selectedPhoto = sender as? [String: Any] {
               let selectedPhoto = sender as? PlacePhoto {
                print(selectedPhoto)
                photoDetailViewController.selectedPhoto = selectedPhoto
                photoDetailViewController.searchItem = viewModel.searchItem
                
            }
        }
    }


//    func fetchPhotos() {
//
//        guard let request = viewModel.setUpHttpPhotosRequest() else {return}
//        let session = URLSession.shared
//
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if let error = error {
//                print("Error: \(error)")
//            } else if let data = data {
//
//                do {
//                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
//                        self.placeImages = jsonArray
//                        self.displayFetchedPhotos()
//
//                    } else {
//                        print("Could not cast JSON to an array of [String: Any] dictionaries")
//                        let jsonString = String(data: data, encoding: .utf8)
//                        print("Raw JSON string: \(String(describing: jsonString))")
//                        self.ErrorMessage()
//
//                    }
//                } catch  let error as NSError {
//                    DispatchQueue.main.async {
//                        print("JSON parsing failed: \(error.localizedDescription)")
//                        self.ErrorMessage()
//                        return
//                    }
//
//                }
//
//            } else {
//                print("No data and no error... something went wrong!")
//                self.ErrorMessage()
//            }
//
//
//        })
//
//        dataTask.resume()
//
//    }

    func ErrorMessage() {
        let alert = UIAlertController(title: "Message", message: "No Photos found for \(viewModel.searchItem)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true)
    }
    
    func displayFetchedPhotos(){
        //self.placeImages = images
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.viewModel.placeImages.isEmpty {
                self.ErrorMessage()
            }
        }
    }

}






