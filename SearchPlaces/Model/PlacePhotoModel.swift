import Foundation

// Defines a structure to represent a photo with its URL components.
struct PlacePhoto {
    // Constants for the prefix and suffix parts of the photo URL.
    let prefix: String
    let suffix: String
    
    // Failable initializer that creates a `PlacePhoto` instance from a dictionary.
    // If either `prefix` or `suffix` is not found, the initializer fails by returning nil.
    init?(dictionary: [String: Any]) {
        // Checks for 'prefix' and 'suffix' keys in the dictionary.
        // If they are not found or not of type String, initialization fails.
        guard let prefix = dictionary["prefix"] as? String,
              let suffix = dictionary["suffix"] as? String else {
            return nil
        }
        self.prefix = prefix
        self.suffix = suffix
    }
    
    // Non-failable initializer that creates a `PlacePhoto` instance with given prefix and suffix strings.
    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }
    
    // Computed property that constructs a full image URL from the prefix and suffix.
    // '200' is presumably a size or other URL component added between the prefix and suffix.
    var imageURL: URL? {
        return URL(string: prefix + "200" + suffix)
    }
}
