//
//  ViewControllerViewModel.swift
//  SearchAPlace
//
//  Created by Anup Kuriakose on 4/11/2023.
//

class HomeViewModel {
    // Using a callback for changes
    var searchItemDidChange: ((String) -> Void)?
    
    var searchItem: String = "" {
        didSet {
            searchItemDidChange?(searchItem)
        }
    }
    
    func updateSearchItem(with text: String) {
        searchItem = text
    }
    
    func searchBarSearchButtonClicked() {
        // Handle other logic related to the search item if needed
        print("Search Clicked: \(searchItem)")
    }
}

