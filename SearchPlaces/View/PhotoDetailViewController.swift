
import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: PhotoDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.photoTitle

        viewModel.fetchImage { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
                if let _ = image {
                    self?.imageView.backgroundColor = UIColor.clear
                    self?.imageView.contentMode = .scaleToFill
                    self?.imageView.layer.borderWidth = 4
                    self?.imageView.layer.cornerRadius = 10
                    self?.imageView.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
    }
}


//import UIKit
//
//class PhotoDetailViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//    //var selectedPhoto: [String: Any]?
//    var selectedPhoto: PlacePhoto?
//    var searchItem = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "\(searchItem) Photo"
//
//        if let selectedPhoto = self.selectedPhoto {
//
//            let prefix = selectedPhoto.prefix
//            let suffix = selectedPhoto.suffix
//
//            let joinURL = URL(string: prefix + "200" + suffix)
//            if let imageURL = joinURL {
//                DispatchQueue.global().async {
//                    let data = try? Data(contentsOf: imageURL)
//                    if let data = data {
//                        let image = UIImage(data: data)
//                        DispatchQueue.main.async {
//                            self.imageView.image = image
//                            self.imageView.backgroundColor = UIColor.clear
//                            self.imageView.contentMode = .scaleToFill
//                            self.imageView.layer.borderWidth = 4
//                            self.imageView.layer.cornerRadius = 10
//                            self.imageView.layer.borderColor = UIColor.white.cgColor
//
//                        }
//                    }
//                }
//            }
//        } else {
//            print("selectedPhoto is nil.")
//        }
//    }
//}
