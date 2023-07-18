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
    
    var searchItem = ""
    
    
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // This method is called whenever the user types or deletes a character
        print("Search text is now: \(searchText)")
        searchItem = searchText
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // This method is called when the user clicks the "Search" button on the keyboard
        print("Search Clicked: \(searchItem)")
        searchBar.resignFirstResponder() // This will hide the keyboard

        // Perform the segue to the PlaceListViewController
        performSegue(withIdentifier: "homeToListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "homeToListSegue",
               let placeListViewController = segue.destination as? PlaceListViewController {
                // Pass the searchItem to the PlaceListViewController
                placeListViewController.searchItem = self.searchItem
            }
        }


}

