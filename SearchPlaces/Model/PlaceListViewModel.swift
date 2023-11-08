import Foundation

// Structure to represent a place with various attributes.
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

    // Initializer that creates a `Place` instance from a dictionary, typically from JSON parsing.
    init(from dict: [String: Any]) {
        // Parses the icon information from the first category if available.
        if let categories = dict["categories"] as? [[String: Any]], let firstCategory = categories.first {
            if let iconDict = firstCategory["icon"] as? [String: Any] {
                self.iconPrefix = iconDict["prefix"] as? String
                self.iconSuffix = iconDict["suffix"] as? String
            }
            
            // Parses the category name from the first category.
            self.categoryName = firstCategory["name"] as? String
        }
        
        // Parses additional place attributes from the dictionary.
        self.distance = dict["distance"] as? Double
        self.fsqId = dict["fsq_id"] as? String
        
        // Parses the latitude and longitude information if available.
        if let geocodes = dict["geocodes"] as? [String: Any], let main = geocodes["main"] as? [String: Any] {
            self.latitude = main["latitude"] as? Double
            self.longitude = main["longitude"] as? Double
        }
        
        // Parses the location information such as address, postcode, and region.
        if let location = dict["location"] as? [String: Any] {
            self.address = location["address"] as? String
            self.postcode = location["postcode"] as? String
            self.region = location["region"] as? String
        }
        
        // Parses the name of the place.
        self.name = dict["name"] as? String
    }
}

// Extension of `Place` to provide a convenience initializer.
extension Place {
    // Convenience initializer to create a `Place` instance directly from individual properties.
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

