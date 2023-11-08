import Foundation
import UIKit

extension PlaceListViewController {

    func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() } // Clear previous contents
        let placeInfo = placeListArray[indexPath.row]
        
        let imageView = createImageView(named: "homeIcon")
        let label1 = createLabel(withText: "\(indexPath.row + 1)", alignment: .center)
        let label2 = createLabel(withText: placeInfo["name"] as? String ?? "N/A", alignment: .center)
        let label3 = createLabel(withText: placeInfo["address"] as? String ?? "N/A", alignment: .center)
        let label4 = createDistanceLabel(withDistance: placeInfo["distance"] as? Double)
        addSubviewsToCell(cell, subviews: [label1, imageView, label2, label3, label4])
        applyConstraintsToSubviewsOfCell(cell, imageView: imageView, labels: [label1, label2, label3, label4])
    }

    func createImageView(named name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func createLabel(withText text: String, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createDistanceLabel(withDistance distance: Double?) -> UILabel {
        let label = UILabel()
        if let distance = distance {
            label.text = String(format: "%.1f km", distance / 1000)
        } else {
            label.text = "N/A"
        }
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func addSubviewsToCell(_ cell: UITableViewCell, subviews: [UIView]) {
        subviews.forEach { cell.contentView.addSubview($0) }
    }

    func applyConstraintsToSubviewsOfCell(_ cell: UITableViewCell, imageView: UIImageView, labels: [UILabel]) {
        let imageSize: CGFloat = 30
        let labelWidthMultipliers: [CGFloat] = [0.1, 0.2, 0.4, 0.2] // Example multipliers

        // Ensure that the number of labels and multipliers match
        assert(labels.count == labelWidthMultipliers.count, "Labels and multipliers count should match")

        var previousAnchor: NSLayoutXAxisAnchor = cell.contentView.leadingAnchor

        // Constraint for the first label
        NSLayoutConstraint.activate([
            labels[0].leadingAnchor.constraint(equalTo: previousAnchor),
            labels[0].centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            labels[0].widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: labelWidthMultipliers[0])
        ])
        
        // Set previousAnchor for the imageView to be after the first label
        previousAnchor = labels[0].trailingAnchor

        // Constraints for imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: previousAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])

        // Now continue with the second label, setting previousAnchor to the imageView's trailing anchor
        previousAnchor = imageView.trailingAnchor

        // Loop through the remaining labels
        for (index, label) in labels.enumerated() where index > 0 { // Start from the second label
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: previousAnchor),
                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                label.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: labelWidthMultipliers[index])
            ])
            // Update the previousAnchor for the next label
            previousAnchor = label.trailingAnchor
        }

        // Constraint for the last label to make sure it does not exceed the contentView's trailing edge
        if let lastLabel = labels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor)
            ])
        }
    }

}
