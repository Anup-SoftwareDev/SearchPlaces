//
//  PlaceListViewViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 5/11/2023.
//

import UIKit
import MapKit
import CoreLocation

class PlaceListViewViewModel {
    var places: [Place] = []
    
    func processJSONResult(_ json: [String: Any]) -> [Place] {
        var parsedPlaces: [Place] = []
        
        if let results = json["results"] as? [[String: Any]] {
            
            for result in results {
                let place = Place(from: result)
                parsedPlaces.append(place)
            }
        }
        
        self.places = parsedPlaces // Store the places in the viewModel
        
        return parsedPlaces
    }
    func convertToArrayOfDictionaries() -> [[String: Any]] {
        var arrayOfDictionaries: [[String: Any]] = []
        
        for place in self.places {
            var dict: [String: Any] = [:]
            dict["iconPrefix"] = place.iconPrefix
            dict["iconSuffix"] = place.iconSuffix
            dict["categoryName"] = place.categoryName
            dict["distance"] = place.distance
            dict["fsqId"] = place.fsqId
            dict["latitude"] = place.latitude
            dict["longitude"] = place.longitude
            dict["address"] = place.address
            dict["postcode"] = place.postcode
            dict["region"] = place.region
            dict["name"] = place.name
            
            arrayOfDictionaries.append(dict)
        }
        
        return arrayOfDictionaries
    }
    
    
    private func setUpHttpPlacesRequest(searchItem: String, currentLocation: CLLocation?) -> URLRequest? {
            let headers = [
                "accept": "application/json",
                "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
            ]

            let limit = 11
            let offset = 0
        let latitude = currentLocation?.coordinate.latitude ?? 0
        let longitude = currentLocation?.coordinate.longitude ?? 0

            let urlString = "https://api.foursquare.com/v3/places/search?query=\(searchItem.replacingOccurrences(of: " ", with: ""))&limit=\(limit)&offset=\(offset)&ll=\(latitude),\(longitude)"

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return nil
            }

            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            return request
        }
        
        func fetchPlaces(searchItem: String, currentLocation: CLLocation?, completion: @escaping (Bool) -> Void) {
            guard let request = setUpHttpPlacesRequest(searchItem: searchItem, currentLocation: currentLocation) else {
                completion(false)
                return
            }
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(false)
                } else if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            self.places = self.processJSONResult(json)
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        print("Failed to load: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }
            dataTask.resume()
        }}





