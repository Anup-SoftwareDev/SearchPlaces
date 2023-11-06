

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    // Outlets
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        
        viewModel.searchItemDidChange = { [weak self] item in
            if self?.viewModel.searchItem != item {
                self?.viewModel.searchItem = item
            }
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = titleLabel.font.withSize(50)
            searchBar.preferredHeight = 50.0
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .white
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchItem(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarSearchButtonClicked()
        searchBar.resignFirstResponder() // This will hide the keyboard
        
        performSegue(withIdentifier: "homeToListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToListSegue",
           let placeListViewController = segue.destination as? PlaceListViewController {
            placeListViewController.searchItem = viewModel.searchItem
        }
    }
}
