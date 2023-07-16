//
//  ViewController.swift
//  SearchPlaces
//
//  Created by Anup Kuriakose on 16/7/2023.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    //Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .white
        
    }

}

