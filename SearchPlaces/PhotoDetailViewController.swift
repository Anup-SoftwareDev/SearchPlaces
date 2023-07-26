
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

                        }
                    }
                }
            }
        } else {
            print("selectedPhoto is nil.")
        }
    }
}
