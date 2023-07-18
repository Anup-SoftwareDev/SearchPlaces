import UIKit

class PlacePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageNames = ["homebgd", "listplaces", "globe", "listplaces", "homebgd", "globe"]  // Replace with your image names
    var collectionView: UICollectionView!
    var searchItem = ""
    
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
    }
    
    // MARK: - UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView(image: UIImage(named: self.imageNames[indexPath.item]))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        return cell
    }
}



//import UIKit
//
//class PlacePhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var imageNames = ["homebgd", "listplaces", "globe", "listplaces", "homebgd", "globe"]  // Replace with your image names
//    var collectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//
//        // calculate cell size to fit two cells with margins side by side
//        let screenWidth = UIScreen.main.bounds.width
//        let cellWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2
//        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)  // Keep width and height same for square cells
//
//        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 0
//        let statusBarHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: statusBarHeight + navigationBarHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - statusBarHeight - navigationBarHeight), collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.backgroundColor = UIColor.gray  // Set the background color to gray
//        self.view.addSubview(collectionView)
//    }
//
//    // MARK: - UICollectionViewDataSource methods
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.imageNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        let imageView = UIImageView(image: UIImage(named: self.imageNames[indexPath.item]))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        cell.backgroundView = imageView
//        return cell
//    }
//}


