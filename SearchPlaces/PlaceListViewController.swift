//
//  PlaceListViewController.swift
//  SearchPlaces
//
//  Created by Anup Kuriakose on 16/7/2023.
//

import UIKit

class PlaceListViewController: UIViewController {

    var searchItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(searchItem) Locations"
    }

}
