import Foundation

class PlacePhotosViewModel {
    var placeImages: [PlacePhoto] = []
    var fourSquareId: String = ""
    var searchItem: String = ""
    
    var photoCount: Int {
        return placeImages.count
    }
    
    
    // Closures for notifying the ViewController about changes
        var didUpdatePhotos: (() -> Void)?
        var didReceiveError: ((Error) -> Void)?

        func fetchPhotos() {
            guard let request = setUpHttpPhotosRequest() else { return }
            let session = URLSession.shared

            let dataTask = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in
                if let error = error {
                    print("Error: \(error)")
                    self?.didReceiveError?(error)
                } else if let data = data {
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            self?.placeImages = jsonArray.compactMap { PlacePhoto(dictionary: $0) }
                            print("JsonArray: \(jsonArray)")
                            print("JsonArrayCompact: \(jsonArray.compactMap { PlacePhoto(dictionary: $0) })")
                            print(self?.placeImages)
                            self?.didUpdatePhotos?()
                        } else {
                            print("Could not cast JSON to an array of [String: Any] dictionaries")
                            let jsonString = String(data: data, encoding: .utf8)
                            print("Raw JSON string: \(String(describing: jsonString))")
                            self?.didReceiveError?(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON parsing failed"]))
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            print("JSON parsing failed: \(error.localizedDescription)")
                            self?.didReceiveError?(error)
                        }
                    }
                } else {
                    print("No data and no error... something went wrong!")
                    self?.didReceiveError?(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
                }
            })

            dataTask.resume()
        }
   
    func setUpHttpPhotosRequest() -> URLRequest?{
        print("it is in fetch photos")
        let headers = [
          "accept": "application/json",
          "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
        ]

        let urlString = "https://api.foursquare.com/v3/places/\(fourSquareId)/photos"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func imageURLString(for indexPath: IndexPath) -> String? {
        guard indexPath.item < placeImages.count else { return nil }

        let imageDict = placeImages[indexPath.item]
        let prefix = imageDict.prefix
        let suffix = imageDict.suffix
        return prefix + "200" + suffix
    }}

