import Foundation
import UIKit

// ViewModel class for handling photo details, such as retrieving and formatting data for a view.
class PhotoDetailViewModel {

    // Optional property that holds the selected photo information.
    var selectedPhoto: PlacePhoto?
    // A string to represent the search or title item associated with the photo.
    var searchItem = ""

    // Computed property that returns the title for the photo. It uses the `searchItem` string.
    var photoTitle: String {
        // Concatenates the search item with the word 'Photo' to create a title.
        return "\(searchItem) Photo"
    }

    // Function to fetch the image data and return it as a UIImage in a completion handler.
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        // Check if `selectedPhoto` has been set, if not print an error and complete with nil.
        guard let selectedPhoto = self.selectedPhoto else {
            print("selectedPhoto is nil.")
            completion(nil)
            return
        }

        // Attempts to construct a URL with the given `selectedPhoto` properties.
        let joinURL = URL(string: selectedPhoto.prefix + "200" + selectedPhoto.suffix)
        
        // If the URL could be constructed, proceed with data fetching.
        if let imageURL = joinURL {
            // Dispatch the data fetch to a background thread to avoid blocking the UI.
            DispatchQueue.global().async {
                // Try to get the raw data from the constructed URL.
                let data = try? Data(contentsOf: imageURL)
                // If data is successfully retrieved, attempt to create a UIImage.
                if let data = data {
                    let image = UIImage(data: data)
                    // Complete with the image on the main thread since UI updates must be on the main thread.
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    // If data could not be retrieved or the image couldn't be created, complete with nil.
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}
