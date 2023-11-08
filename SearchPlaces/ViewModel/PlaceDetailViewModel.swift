import Foundation

// ViewModel to handle the presentation logic for place details.
class PlaceDetailViewModel {
    // Stored property for the details of the place.
    var placeDetail: PlaceDetail

    // Computed property to construct the icon URL from the icon prefix and suffix.
    var iconURL: URL? {
        return URL(string: placeDetail.iconPrefix + "100" + placeDetail.iconSuffix)
    }

    // Computed property to format the place details into a specific structure for display.
    var cellData: [(String, String)] {
        return [
            ("Category:", placeDetail.categoryName),
            ("Address:", placeDetail.address),
            ("Region:", placeDetail.region),
            // Formats the distance from meters to kilometers with one decimal place.
            ("Distance", String(format: "%.1f km", placeDetail.distance / 1000)),
            // Converts the latitude and longitude to string representations.
            ("Latitude", String(placeDetail.latitude)),
            ("Longitude", String(placeDetail.longitude))
        ]
    }

    // Initializer that sets the place detail.
    init(detail: PlaceDetail) {
        self.placeDetail = detail
    }
}
