

import UIKit
import MapKit

extension UIViewController {
    func noPlacesAlert(searchItem: String) {
        let alert = UIAlertController(title: "Alert", message: "No Places found for \(searchItem)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    
}

