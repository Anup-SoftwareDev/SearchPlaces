import Quick
import Nimble
import CoreLocation
import MapKit

@testable import SearchAPlace

class PlaceRouteViewModelTests: QuickSpec {
    override class func spec() {
        describe("PlaceRouteViewModel") {
            var viewModel: PlaceRouteViewModel!
            var mockPlace: PlaceRoute!

            beforeEach {
                // Initialize mockPlace here
                mockPlace = PlaceRoute(latitude: 40.1, longitude: 50.1, name: "Mock Place Name")
                viewModel = PlaceRouteViewModel(place: mockPlace)
            }

            describe("fetchRouteDetails") {
                context("when a valid route is found") {
                    it("should set the infoText property with distance and time") {
                        let mockLocation = CLLocation(latitude: 40.1, longitude: 50.1)
                        
                        // This is a mock route for testing purposes
                        let mockRoute = MKRoute()
                        // Set properties for mockRoute like mockRoute.distance or mockRoute.expectedTravelTime if they are mutable

                        // Mock the MKDirections to return the mockRoute
                        // You might need to use dependency injection or a mocking framework for this.

                        viewModel.fetchRouteDetails(from: mockLocation) { (route, error) in
                            expect(error).to(beNil())
                            expect(route).toNot(beNil())
                            expect(viewModel.infoText).toNot(beNil())
                            // You can further validate the content of viewModel.infoText if you wish
                        }
                    }
                }

                context("when no route is found") {
                    it("should return a no route error") {
                        let mockLocation = CLLocation(latitude: 40.1, longitude: 50.1)
                        
                        // Mock the MKDirections to return no routes
                        // You might need to use dependency injection or a mocking framework for this.

                        viewModel.fetchRouteDetails(from: mockLocation) { (route, error) in
                            expect(error).toNot(beNil())
                            expect(route).to(beNil())
                            expect((error as NSError?)?.code).to(equal(1001))
                        }
                    }
                }

                // You can add other contexts such as when an unexpected error occurs, etc.
            }
        }
    }
}
