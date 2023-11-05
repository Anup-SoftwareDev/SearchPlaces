//
//  PlaceDetailViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 5/11/2023.
//

import Foundation

class PlaceDetailViewModel {
    var placeDetail: PlaceDetail
    var iconURL: URL? {
        return URL(string: placeDetail.iconPrefix + "100" + placeDetail.iconSuffix)
    }
    var cellData: [(String, String)] {
        return [
            ("Category:", placeDetail.categoryName),
            ("Address:", placeDetail.address),
            ("Region:", placeDetail.region),
            ("Distance", String(format: "%.1f km", placeDetail.distance / 1000)),
            ("Latitude", String(placeDetail.latitude)),
            ("Longitude", String(placeDetail.longitude))
        ]
    }

    init(detail: PlaceDetail) {
        self.placeDetail = detail
    }
}
