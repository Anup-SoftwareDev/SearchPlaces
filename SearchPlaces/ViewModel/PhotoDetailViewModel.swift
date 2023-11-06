//
//  PhotoDetailViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 6/11/2023.
//

import Foundation
import UIKit

class PhotoDetailViewModel {

    var selectedPhoto: PlacePhoto?
    var searchItem = ""

    var photoTitle: String {
        return "\(searchItem) Photo"
    }

    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let selectedPhoto = self.selectedPhoto else {
            print("selectedPhoto is nil.")
            completion(nil)
            return
        }

        let joinURL = URL(string: selectedPhoto.prefix + "200" + selectedPhoto.suffix)
        
        if let imageURL = joinURL {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
