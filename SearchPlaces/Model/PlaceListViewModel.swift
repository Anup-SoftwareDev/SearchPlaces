//
//  PlaceListViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 4/11/2023.
//

import Foundation

struct Place {
    var iconPrefix: String?
    var iconSuffix: String?
    var categoryName: String?
    var distance: Double?
    var fsqId: String?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var postcode: String?
    var region: String?
    var name: String?

    init(from dict: [String: Any]) {
        if let categories = dict["categories"] as? [[String: Any]], let firstCategory = categories.first {
            print("Categories:\(categories)")
            if let iconDict = firstCategory["icon"] as? [String: Any] {
                        self.iconPrefix = iconDict["prefix"] as? String
                        self.iconSuffix = iconDict["suffix"] as? String
            }
            
            self.categoryName = firstCategory["name"] as? String
        }
        self.distance = dict["distance"] as? Double
        self.fsqId = dict["fsq_id"] as? String
        
        if let geocodes = dict["geocodes"] as? [String: Any], let main = geocodes["main"] as? [String: Any] {
            self.latitude = main["latitude"] as? Double
            self.longitude = main["longitude"] as? Double
        }
        
        if let location = dict["location"] as? [String: Any] {
            self.address = location["address"] as? String
            self.postcode = location["postcode"] as? String
            self.region = location["region"] as? String
        }
        
        self.name = dict["name"] as? String
    }
}

extension Place {
    init(iconPrefix: String, iconSuffix: String, categoryName: String, distance: Double, fsqId: String, latitude: Double, longitude: Double, address: String, postcode: String, region: String, name: String) {
        self.iconPrefix = iconPrefix
        self.iconSuffix = iconSuffix
        self.categoryName = categoryName
        self.distance = distance
        self.fsqId = fsqId
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.postcode = postcode
        self.region = region
        self.name = name
    }
}
