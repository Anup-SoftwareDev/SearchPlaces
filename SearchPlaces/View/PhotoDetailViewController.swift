import UIKit

// MARK: - PhotoDetailViewController Declaration
class PhotoDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var viewModel: PhotoDetailViewModel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration methods called during view loading
        setUpPhotoTitle()
        setUpImage()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the navigation bar title to the photo's title.
    private func setUpPhotoTitle() {
        // The navigation title is set to the photo title provided by the viewModel
        self.title = viewModel.photoTitle
    }
    
    /// Fetches and sets up the photo image.
    private func setUpImage() {
        // Fetch the image through the viewModel
        viewModel.fetchImage { [weak self] image in
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                // Assign the fetched image to the imageView
                self?.imageView.image = image
                
                // If an image is successfully fetched, update the imageView properties
                if let _ = image {
                    self?.imageView.backgroundColor = UIColor.clear
                    self?.imageView.contentMode = .scaleAspectFill // changed to scaleAspectFill for better image display
                    self?.imageView.layer.borderWidth = 4
                    self?.imageView.layer.cornerRadius = 10
                    self?.imageView.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
    }
}

