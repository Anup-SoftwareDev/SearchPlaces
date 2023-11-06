import Quick
import Nimble
@testable import SearchAPlace

class PhotoDetailViewModelTests: QuickSpec {
    override class func spec() {
        describe("PhotoDetailViewModel") {
            var viewModel: PhotoDetailViewModel!

            beforeEach {
                viewModel = PhotoDetailViewModel()
            }

            describe("photoTitle") {
                context("when searchItem is set") {
                    it("should return the correct title") {
                        viewModel.searchItem = "Test"
                        expect(viewModel.photoTitle).to(equal("Test Photo"))
                    }
                }
            }

            describe("fetchImage") {
                context("when selectedPhoto is nil") {
                    it("should return nil and print an error message") {
                        viewModel.selectedPhoto = nil
                        viewModel.fetchImage { image in
                            expect(image).to(beNil())
                        }
                    }
                }

                context("when selectedPhoto is set") {
                    beforeEach {
                        let photo = PlacePhoto(prefix: "http://example.com/", suffix: "/image1.png")
                        viewModel.selectedPhoto = photo
                    }

                    it("should return an image if the URL is valid and data can be fetched") {
                        // Mocking data fetching or the Data(contentsOf:) is more complex and might require dependency injection or third-party libraries.
                        // This is just a basic test and may not cover that scenario.
                        viewModel.fetchImage { image in
                            expect(image).toNot(beNil())
                        }
                    }

                    it("should return nil if data cannot be fetched or the image cannot be created") {
                        // Similar to the above, you might need a more complex setup to test this scenario fully.
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
