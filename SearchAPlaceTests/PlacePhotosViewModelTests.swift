import Quick
import Nimble
@testable import SearchAPlace

class PlacePhotosViewModelTests: QuickSpec {
    override class func spec() {
        describe("PlacePhotosViewModel") {
            var viewModel: PlacePhotosViewModel!
            
            beforeEach {
                viewModel = PlacePhotosViewModel()
            }
            
            context("initial state") {
                it("should have zero photos") {
                    expect(viewModel.photoCount).to(equal(0))
                }
            }

            context("setting up HTTP request for photos") {
                it("should produce correct URL for a given fourSquareId") {
                    viewModel.fourSquareId = "sampleID"
                    let request = viewModel.setUpHttpPhotosRequest()
                    expect(request?.url?.absoluteString).to(equal("https://api.foursquare.com/v3/places/sampleID/photos"))
                }
        

//                it("should have correct headers") {
//                    let expectedHeaders = [
//                        "accept": "application/json",
//                        "Authorization": "fsq30DgtIq+UgKbZuc/qp6FBAAFSInBaxmhfo3qHxb0ylUI="
//                    ]
//                    let request = viewModel.setUpHttpPhotosRequest()
//                    expect(request?.allHTTPHeaderFields).to(equal(expectedHeaders))
//                }
            }
            
            context("forming image URLs") {
                beforeEach {
                    let photo1 = PlacePhoto(prefix: "http://example.com/", suffix: "/image1.png")
                    let photo2 = PlacePhoto(prefix: "http://example.com/", suffix: "/image2.png")
                    viewModel.placeImages = [photo1, photo2]
                }

                it("should produce correct URL for the first photo") {
                    let indexPath = IndexPath(item: 0, section: 0)
                    expect(viewModel.imageURLString(for: indexPath)).to(equal("http://example.com/200/image1.png"))
                }

                it("should produce correct URL for the second photo") {
                    let indexPath = IndexPath(item: 1, section: 0)
                    expect(viewModel.imageURLString(for: indexPath)).to(equal("http://example.com/200/image2.png"))
                }

                it("should return nil for an out of bounds index") {
                    let indexPath = IndexPath(item: 2, section: 0)
                    expect(viewModel.imageURLString(for: indexPath)).to(beNil())
                }
            }
        }
    }
}
