
import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedPhoto: [String: Any]?
    var searchItem = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(searchItem) Photo"
        
        if let selectedPhoto = self.selectedPhoto {
            print("Selectedphoto: \(selectedPhoto)")

            let prefix = selectedPhoto["prefix"] as? String ?? "N/A"
            let suffix = selectedPhoto["suffix"] as? String ?? "N/A"
            
            let joinURL = URL(string: prefix + "200" + suffix)
            if let imageURL = joinURL {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.imageView.backgroundColor = UIColor.clear
                            self.imageView.contentMode = .scaleToFill
                            self.imageView.layer.borderWidth = 4
                            self.imageView.layer.cornerRadius = 10
                            self.imageView.layer.borderColor = UIColor.white.cgColor

                            // If device is iPad, set the imageView height to 500 and set left and right margins
//                            if UIDevice.current.userInterfaceIdiom == .pad {
//                                //self.imageView.translatesAutoresizingMaskIntoConstraints = false
//
//                                self.imageView.translatesAutoresizingMaskIntoConstraints = false
//                                NSLayoutConstraint.activate([
//
//                                    self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
//                                    self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100),
//                                    self.imageView.heightAnchor.constraint(equalToConstant: 2000)
//                                ])
//                            }
                        }
                    }
                }
            }
        } else {
            print("selectedPhoto is nil.")
        }
    }
}
