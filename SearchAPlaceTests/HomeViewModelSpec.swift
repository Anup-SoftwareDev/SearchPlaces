import Quick
import Nimble
@testable import SearchAPlace

class HomeViewModelSpec: QuickSpec {
    override class func spec() {
        // This describes a suite of tests for the HomeViewModel
        describe("HomeViewModel") {
            var viewModel: HomeViewModel!
            
            // This closure is called before each test to ensure a fresh instance of the ViewModel
            beforeEach {
                viewModel = HomeViewModel()
            }
            
            // This block tests the behavior when the search item changes
            context("when search item changes") {
                // The test checks if the ViewModel notifies about the change
                it("should notify about changes") {
                    var receivedSearchItem: String?
                    // Assign a closure to simulate listener for search item changes
                    viewModel.searchItemDidChange = { newItem in
                        receivedSearchItem = newItem
                    }
                    
                    // Trigger the update of the search item
                    viewModel.updateSearchItem(with: "test")
                    
                    // Expect the received item to eventually equal the new search term
                    expect(receivedSearchItem).toEventually(equal("test"))
                }
            }
            
            // This block tests the behavior when the search bar's search button is clicked
            context("when search bar search button clicked") {
                // The test ensures the search item is updated correctly
                it("should have the correct search item") {
                    // Update the search item to a test value
                    viewModel.updateSearchItem(with: "buttonTest")
                    
                    // Expect the search item to be the value that was set
                    expect(viewModel.searchItem).to(equal("buttonTest"))
                }
            }
        }
    }
}
