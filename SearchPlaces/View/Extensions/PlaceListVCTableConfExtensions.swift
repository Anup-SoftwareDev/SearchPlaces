import Foundation
import UIKit

extension PlaceListViewController {
    
    // Configures a table view cell with place information
    func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Clear out any old view elements from the cell's content view
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Retrieve the corresponding place info from the array
        let placeInfo = placeListArray[indexPath.row]
        
        // Create UI elements for the cell
        let imageView = createImageView(named: "homeIcon")
        let label1 = createLabel(withText: "\(indexPath.row + 1)", alignment: .center)
        let label2 = createLabel(withText: placeInfo["name"] as? String ?? "N/A", alignment: .center)
        let label3 = createLabel(withText: placeInfo["address"] as? String ?? "N/A", alignment: .center)
        let label4 = createDistanceLabel(withDistance: placeInfo["distance"] as? Double)
        
        // Add these UI elements to the cell's content view
        addSubviewsToCell(cell, subviews: [label1, imageView, label2, label3, label4])
        // Apply constraints to layout the subviews within the cell
        applyConstraintsToSubviewsOfCell(cell, imageView: imageView, labels: [label1, label2, label3, label4])
    }
    
    // Creates an image view for the cell
    func createImageView(named name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // Creates a generic label for the cell
    func createLabel(withText text: String, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Creates a label specifically for displaying distance
    func createDistanceLabel(withDistance distance: Double?) -> UILabel {
        let label = UILabel()
        if let distance = distance {
            // Convert the distance to kilometers and format it as a string
            label.text = String(format: "%.1f km", distance / 1000)
        } else {
            label.text = "N/A"
        }
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Adds subviews to a table view cell
    func addSubviewsToCell(_ cell: UITableViewCell, subviews: [UIView]) {
        subviews.forEach { cell.contentView.addSubview($0) }
    }
    
    // Applies constraints to the subviews in the cell
    func applyConstraintsToSubviewsOfCell(_ cell: UITableViewCell, imageView: UIImageView, labels: [UILabel]) {
        let imageSize: CGFloat = 30 // Fixed image size for uniformity
        
        // Width multipliers for the labels to define their proportional widths in the cell
        let labelWidthMultipliers: [CGFloat] = [0.10, 0.25, 0.25, 0.40] // Adjust these multipliers according to your design
        
        // Check to ensure the labels count matches the count of width multipliers
        assert(labels.count == labelWidthMultipliers.count, "Labels and multipliers count should match")
        
        // Set up the leading anchor for the first label
        var previousAnchor: NSLayoutXAxisAnchor = cell.contentView.leadingAnchor
        
        // Loop through the labels and apply constraints
        for (index, label) in labels.enumerated() {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: previousAnchor),
                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                label.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: labelWidthMultipliers[index])
            ])
            // Update the previousAnchor to the trailing anchor of the current label
            previousAnchor = label.trailingAnchor
        }
        
        // Constraints for imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: previousAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        // Update previousAnchor to imageView's trailing for the next element if needed
        previousAnchor = imageView.trailingAnchor
        
        // Ensure the last label's trailing edge does not exceed the cell's trailing edge
        if let lastLabel = labels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor)
            ])
        }
    }

}

//import Foundation
//import UIKit
//
//extension PlaceListViewController {
//
//
//
//     func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.contentView.subviews.forEach { $0.removeFromSuperview() } // Clear previous contents
//        let placeInfo = placeListArray[indexPath.row]
//
//        let imageView = createImageView(named: "homeIcon")
//        let label1 = createLabel(withText: "\(indexPath.row + 1)", alignment: .center)
//        let label2 = createLabel(withText: placeInfo["name"] as? String ?? "N/A", alignment: .center)
//        let label3 = createLabel(withText: placeInfo["address"] as? String ?? "N/A", alignment: .center)
//        let label4 = createDistanceLabel(withDistance: placeInfo["distance"] as? Double)
//
//        addSubviewsToCell(cell, subviews: [label1, imageView, label2, label3, label4])
//        applyConstraintsToSubviewsOfCell(cell, imageView: imageView, labels: [label1, label2, label3, label4])
//    }
//
//     func createImageView(named name: String) -> UIImageView {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: name)
//        imageView.contentMode = .scaleToFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }
//
//     func createLabel(withText text: String, alignment: NSTextAlignment) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.textAlignment = alignment
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//     func createDistanceLabel(withDistance distance: Double?) -> UILabel {
//        let label = UILabel()
//        if let distance = distance {
//            label.text = String(format: "%.1f km", distance / 1000)
//        } else {
//            label.text = "N/A"
//        }
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//    func addSubviewsToCell(_ cell: UITableViewCell, subviews: [UIView]) {
//        subviews.forEach { cell.contentView.addSubview($0) }
//    }
//
//    func applyConstraintsToSubviewsOfCell(_ cell: UITableViewCell, imageView: UIImageView, labels: [UILabel]) {
//        let imageSize: CGFloat = 30
//        // Ensure you have a width multiplier for each label
//        let labelWidthMultipliers: [CGFloat] = [0.10, 0.25, 0.25, 0.40] // Adjust these multipliers according to your design
//
//        // Ensure that the number of labels and multipliers match
//        assert(labels.count == labelWidthMultipliers.count, "Labels and multipliers count should match")
//
//        var previousAnchor: NSLayoutXAxisAnchor = cell.contentView.leadingAnchor
//        for (index, label) in labels.enumerated() {
//            NSLayoutConstraint.activate([
//                label.leadingAnchor.constraint(equalTo: previousAnchor),
//                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
//                label.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: labelWidthMultipliers[index])
//            ])
//            // Update the previousAnchor for the next label
//            previousAnchor = label.trailingAnchor
//        }
//
//        // Add constraints to imageView
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: previousAnchor),
//            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: imageSize),
//            imageView.heightAnchor.constraint(equalToConstant: imageSize)
//        ])
//
//        // If you're setting the imageView after the first label, this should be the second item's trailing anchor
//        previousAnchor = imageView.trailingAnchor
//
//        // Constraint for the last label to make sure it does not exceed the contentView's trailing edge
//        if let lastLabel = labels.last {
//            NSLayoutConstraint.activate([
//                lastLabel.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor)
//            ])
//        }
//    }
//
//
//
//}
