import Foundation

struct PlacePhoto {
    let prefix: String
    let suffix: String
    
    init?(dictionary: [String: Any]) {
        guard let prefix = dictionary["prefix"] as? String,
              let suffix = dictionary["suffix"] as? String else {
            return nil
        }
        self.prefix = prefix
        self.suffix = suffix
    }
    
    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }
    
    var imageURL: URL? {
        return URL(string: prefix + "200" + suffix)
    }
}
