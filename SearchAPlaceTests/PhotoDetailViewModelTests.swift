import Quick
import Nimble
@testable import SearchAPlace

class PhotoDetailViewModelTests: QuickSpec {
    override class func spec() {
        // This describes a suite of tests for the PhotoDetailViewModel
        describe("PhotoDetailViewModel") {
            var viewModel: PhotoDetailViewModel!

            // This closure is called before each test to ensure a fresh instance of the ViewModel
            beforeEach {
                viewModel = PhotoDetailViewModel()
            }

            // This block tests the photoTitle computed property
            describe("photoTitle") {
                // Contextual block for when a search item is set
                context("when searchItem is set") {
                    // The test checks if the photoTitle returns the expected string
                    it("should return the correct title") {
                        viewModel.searchItem = "Test"
                        expect(viewModel.photoTitle).to(equal("Test Photo"))
                    }
                }
            }

            // This block tests the fetchImage method of the ViewModel
            describe("fetchImage") {
                // Contextual block for when no photo is selected
                context("when selectedPhoto is nil") {
                    // The test expects a nil image result and possibly an error message
                    it("should return nil and print an error message") {
                        viewModel.selectedPhoto = nil
                        viewModel.fetchImage { image in
                            expect(image).to(beNil())
                        }
                    }
                }

                // Contextual block for when a photo is selected
                context("when selectedPhoto is set") {
                    // This is setup before the tests to provide a consistent state
                    beforeEach {
                        let photo = PlacePhoto(prefix: "http://example.com/", suffix: "/image1.png")
                        viewModel.selectedPhoto = photo
                    }

                    // This test checks if the fetchImage method returns a non-nil image for a valid URL
                    it("should return an image if the URL is valid and data can be fetched") {
                        viewModel.fetchImage { image in
                            expect(image).toNot(beNil())
                        }
                    }

                    // This test checks if the fetchImage method correctly handles invalid URLs
                    it("should return nil if data cannot be fetched or the image cannot be created") {
                        viewModel.selectedPhoto = PlacePhoto(prefix: "http://invalid-url.com/", suffix: "/invalid-image.png")
                        viewModel.fetchImage { image in
                            expect(image).to(beNil())
                        }
                    }
                }
            }
        }
    }
}

