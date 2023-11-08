import Quick
import Nimble
@testable import SearchAPlace // Replace with your actual module name

class PlaceListViewViewModelSpec: QuickSpec {
    override class func spec() {
        // Describing the test suite for PlaceListViewViewModel
        describe("PlaceListViewViewModel") {
            var viewModel: PlaceListViewViewModel!
            
            // Before each test, initialize the ViewModel
            beforeEach {
                viewModel = PlaceListViewViewModel()
            }
            
            // Describe block for the processJSONResult method
            describe("processJSONResult") {
                it("should parse the JSON correctly") {
                    // Providing a sample JSON dictionary to mimic a network response
                    let sampleJSON: [String: Any] = [
                        "results": [
                            [
                                "iconPrefix": "prefix1",
                                "iconSuffix": "suffix1",
                                "categoryName": "category1",
                                "distance": 10,
                                "fsqId": "id1",
                                "latitude": 40.1,
                                "longitude": 50.1,
                                "address": "address1",
                                "postcode": "postcode1",
                                "region": "region1",
                                "name": "name1"
                            ],
                            [
                                "iconPrefix": "prefix2",
                                "iconSuffix": "suffix2",
                                "categoryName": "category2",
                                "distance": 20,
                                "fsqId": "id2",
                                "latitude": 40.2,
                                "longitude": 50.2,
                                "address": "address2",
                                "postcode": "postcode2",
                                "region": "region2",
                                "name": "name2"
                            ]
                        ]
                    ]
                    // Process the JSON and check if the result is as expected
                    let places = viewModel.processJSONResult(sampleJSON)
                    expect(places.count).to(equal(2))
                }
            }
            
            // Describe block for the convertToArrayOfDictionaries method
            describe("convertToArrayOfDictionaries") {
                it("should convert places to array of dictionaries correctly") {
                    // Create a sample place to test the conversion
                    let place = Place(iconPrefix: "prefix1", iconSuffix: "suffix1", categoryName: "category1", distance: 10, fsqId: "id1", latitude: 40.1, longitude: 50.1, address: "address1", postcode: "postcode1", region: "region1", name: "name1")
                    viewModel.places = [place]
                    
                    // Convert places to array of dictionaries
                    let dicts = viewModel.convertToArrayOfDictionaries()
                    // Validate the conversion
                    expect(dicts.count).to(equal(1))
                    expect(dicts.first?["iconPrefix"] as? String).to(equal(place.iconPrefix))
                    expect(dicts[0]["iconPrefix"] as? String).to(equal(place.iconPrefix))
                    expect(dicts[0]["iconSuffix"] as? String).to(equal(place.iconSuffix))
                }
            }
        }
    }
}
