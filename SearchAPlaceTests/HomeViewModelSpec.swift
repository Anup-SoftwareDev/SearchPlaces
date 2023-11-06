import Quick
import Nimble
@testable import SearchAPlace

class HomeViewModelSpec: QuickSpec {
    override class func spec() {
        describe("HomeViewModel") {
            var viewModel: HomeViewModel!
            
            beforeEach {
                viewModel = HomeViewModel()
            }
            
            context("when search item changes") {
                it("should notify about changes") {
                    var receivedSearchItem: String?
                    viewModel.searchItemDidChange = { newItem in
                        receivedSearchItem = newItem
                    }
                    
                    viewModel.updateSearchItem(with: "test")
                    
                    expect(receivedSearchItem).toEventually(equal("test"))
                }
            }
            
            context("when search bar search button clicked") {
                it("should have the correct search item") {
                    viewModel.updateSearchItem(with: "buttonTest")
                    expect(viewModel.searchItem).to(equal("buttonTest"))
                    
                    // This simply tests that the searchItem value is as expected.
                    // The print statement is side-effect and can't be tested easily without swizzling or other techniques.
                }
            }
        }
    }
}
