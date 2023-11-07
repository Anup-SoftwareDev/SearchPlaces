import UIKit

// MARK: - ViewController Declaration
class ViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel = HomeViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration methods called during view loading
        setupSearchBar()
        assignSearchItemDidChange()
        searchBarAdjustForIpad()
    }
    
    // MARK: - Setup Methods
    
    /// Assigns a closure to handle the change of the search item in the view model.
    private func assignSearchItemDidChange() {
        viewModel.searchItemDidChange = { [weak self] item in
            // Ensuring the search item is updated only when it has indeed changed
            if self?.viewModel.searchItem != item {
                self?.viewModel.searchItem = item
            }
        }
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    /// Called when the search text changes.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Forward the search text to the view model for processing
        viewModel.updateSearchItem(with: searchText)
    }
    
    /// Called when the search button on the keyboard is clicked.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Request the view model to handle the search button click
        viewModel.searchBarSearchButtonClicked()
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Initiate segue to the list view
        performSegue(withIdentifier: "homeToListSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    /// Prepares for the segue to the list view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if the segue is the expected one and set up the destination view controller
        if segue.identifier == "homeToListSegue",
           let placeListViewController = segue.destination as? PlaceListViewController {
            // Pass the current search item to the list view controller
            placeListViewController.searchItem = viewModel.searchItem
        }
    }
}

