import Quick
import Nimble
@testable import SearchAPlace

class PlacePhotosViewModelTests: QuickSpec {
    override class func spec() {
        // Start of the test suite for PlacePhotosViewModel
        describe("PlacePhotosViewModel") {
            var viewModel: PlacePhotosViewModel!
            
            // Set up for the viewModel before each test case
            beforeEach {
                // Initialize the ViewModel before each test
                viewModel = PlacePhotosViewModel()
            }
            
            // Context for initial state of viewModel
            context("initial state") {
                it("should have zero photos") {
                    // Test if the initial photo count is zero
                    expect(viewModel.photoCount).to(equal(0))
                }
            }

            // Context for setting up the HTTP request for photos
            context("setting up HTTP request for photos") {
                it("should produce correct URL for a given fourSquareId") {
                    // Set a sample Foursquare ID for the test
                    viewModel.fourSquareId = "sampleID"
                    // Create the request
                    let request = viewModel.setUpHttpPhotosRequest()
                    // Validate if the URL is correctly formed
                    expect(request?.url?.absoluteString).to(equal("https://api.foursquare.com/v3/places/sampleID/photos"))
                }
            }
            
            // Context for forming image URLs from PlacePhoto objects
            context("forming image URLs") {
                beforeEach {
                    // Setup mock data with two sample photos
                    let photo1 = PlacePhoto(prefix: "http://example.com/", suffix: "/image1.png")
                    let photo2 = PlacePhoto(prefix: "http://example.com/", suffix: "/image2.png")
                    viewModel.placeImages = [photo1, photo2]
                }

                it("should produce correct URL for the first photo") {
                    // Define index path for the first photo
                    let indexPath = IndexPath(item: 0, section: 0)
                    // Expect the viewModel to return the correct URL string for the first photo
                    expect(viewModel.imageURLString(for: indexPath)).to(equal("http://example.com/200/image1.png"))
                }

                it("should produce correct URL for the second photo") {
                    // Define index path for the second photo
                    let indexPath = IndexPath(item: 1, section: 0)
                    // Expect the viewModel to return the correct URL string for the second photo
                    expect(viewModel.imageURLString(for: indexPath)).to(equal("http://example.com/200/image2.png"))
                }

                it("should return nil for an out of bounds index") {
                    // Define index path that is out of the bounds of the placeImages array
                    let indexPath = IndexPath(item: 2, section: 0)
                    // Expect the viewModel to return nil when the index is out of bounds
                    expect(viewModel.imageURLString(for: indexPath)).to(beNil())
                }
            }
        }
    }
}
