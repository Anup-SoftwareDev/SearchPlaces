import Quick
import Nimble
@testable import SearchAPlace

class PlaceDetailViewModelTests: QuickSpec {
    override class func spec() {
        describe("PlaceDetailViewModel") {
            
            context("when initialized with sample PlaceDetail") {
                let sampleDetail = PlaceDetail(iconPrefix: "http://example.com/",
                                               iconSuffix: "/sample.png",
                                               categoryName: "Cafe",
                                               address: "123 Sample St",
                                               region: "Sample Region",
                                               distance: 5000, // 5 kilometers
                                               latitude: 40.5,
                                               longitude: -74.0)
                
                let viewModel = PlaceDetailViewModel(detail: sampleDetail)

                it("should produce correct iconURL") {
                    expect(viewModel.iconURL?.absoluteString).to(equal("http://example.com/100/sample.png"))
                }

                it("should produce correct cellData for category") {
                    expect(viewModel.cellData[0]).to(equal(("Category:", "Cafe")))
                }

                it("should produce correct cellData for address") {
                    expect(viewModel.cellData[1]).to(equal(("Address:", "123 Sample St")))
                }

                it("should produce correct cellData for region") {
                    expect(viewModel.cellData[2]).to(equal(("Region:", "Sample Region")))
                }

                it("should produce correct cellData for distance") {
                    expect(viewModel.cellData[3]).to(equal(("Distance", "5.0 km")))
                }

                it("should produce correct cellData for latitude") {
                    expect(viewModel.cellData[4]).to(equal(("Latitude", "40.5")))
                }

                it("should produce correct cellData for longitude") {
                    expect(viewModel.cellData[5]).to(equal(("Longitude", "-74.0")))
                }
            }
        }
    }
}
