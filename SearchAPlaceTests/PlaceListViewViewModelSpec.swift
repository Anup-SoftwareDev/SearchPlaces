import Quick
import Nimble
@testable import SearchAPlace // Replace with your actual module name

class PlaceListViewViewModelSpec: QuickSpec {
    override class func spec() {
        describe("PlaceListViewViewModel") {
            var viewModel: PlaceListViewViewModel!
            
            beforeEach {
                viewModel = PlaceListViewViewModel()
            }
            
            describe("processJSONResult") {
                it("should parse the JSON correctly") {
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
                                                    ] as [String : Any],
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
                    let places = viewModel.processJSONResult(sampleJSON)
                    expect(places.count).to(equal(2))
                    //expect(places.first?.iconPrefix).to(equal("prefix1"))
                    
                }
            }
            
            describe("convertToArrayOfDictionaries") {
                it("should convert places to array of dictionaries correctly") {
                    // Assuming you have a sample place
                    let place = Place(iconPrefix: "prefix1", iconSuffix: "suffix1", categoryName: "category1", distance: 10, fsqId: "id1", latitude: 40.1, longitude: 50.1, address: "address1", postcode: "postcode1", region: "region1", name: "name1")
                    viewModel.places = [place]
                    
                    
                    let dicts = viewModel.convertToArrayOfDictionaries()
                    expect(dicts.count).to(equal(1))
                    expect(dicts.first?["iconPrefix"] as? String).to(equal(place.iconPrefix))
                    expect(dicts[0]["iconPrefix"] as? String).to(equal(place.iconPrefix))
                    expect(dicts[0]["iconSuffix"] as? String).to(equal(place.iconSuffix))
                    // Continue with other properties and checks
                }
            }
            
            // Other tests would include network calls which would require mocking the URLSession or using dependency injection to provide a mock network layer. This ensures you don't make actual network requests during unit testing.
        }
    }
}
