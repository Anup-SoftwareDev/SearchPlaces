import Foundation

// ViewModel to manage the photos related to a place.
class PlacePhotosViewModel {
    // Array to store the photos of a place.
    var placeImages: [PlacePhoto] = []
    // The Foursquare ID for the specific place.
    var fourSquareId: String = ""
    // The search item or term associated with the photos.
    var searchItem: String = ""
    
    // Computed property to get the count of photos.
    var photoCount: Int {
        return placeImages.count
    }
    
    // Closure called when photos are updated.
    var didUpdatePhotos: (() -> Void)?
    // Closure called when there is an error in fetching photos.
    var didReceiveError: ((Error) -> Void)?

    // Function to fetch photos from the network.
    func fetchPhotos() {
        // Setup the network request for fetching photos.
        guard let request = setUpHttpPhotosRequest() else { return }
        let session = URLSession.shared

        // Perform the network data task.
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                // If there is an error, call the error closure.
                print("Error: \(error)")
                self?.didReceiveError?(error)
            } else if let data = data {
                do {
                    // Attempt to deserialize the JSON data.
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        // Map the JSON data to `PlacePhoto` objects and update the photos array.
                        self?.placeImages = jsonArray.compactMap { PlacePhoto(dictionary: $0) }
                        // Notify the ViewController that photos have been updated.
                        self?.didUpdatePhotos?()
                    } else {
                        // Handle the error if JSON data can't be parsed.
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON parsing failed"])
                        self?.didReceiveError?(error)
                    }
                } catch let error {
                    // Handle any parsing errors.
                    DispatchQueue.main.async {
                        self?.didReceiveError?(error)
                    }
                }
            } else {
                // Handle the case where there is no data and no error.
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                self?.didReceiveError?(error)
            }
        }

        // Resume the task to start the network call.
        dataTask.resume()
    }

    // Function to set up the HTTP request for fetching photos.
    func setUpHttpPhotosRequest() -> URLRequest? {
        // HTTP headers for the request.
        let headers = [
            "accept": "application/json",
            "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
        ]

        // Construct the URL string using the Foursquare ID.
        let urlString = "https://api.foursquare.com/v3/places/\(fourSquareId)/photos"
        guard let url = URL(string: urlString) else {
            // If the URL is invalid, return nil.
            return nil
        }
        // Create a URLRequest object with the URL and headers.
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    // Function to get the image URL string for a given index path.
    func imageURLString(for indexPath: IndexPath) -> String? {
        // Ensure the index is within bounds of the photos array.
        guard indexPath.item < placeImages.count else { return nil }

        // Get the specific photo object and construct the image URL string.
        let imageDict = placeImages[indexPath.item]
        return imageDict.prefix + "200" + imageDict.suffix
    }
}
