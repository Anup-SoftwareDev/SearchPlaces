import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageNames = ["homebgd", "homeIcon", "listplaces"] // replace with your image names
        
        // Create a scroll view and set its properties
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: (view.bounds.width) * CGFloat(imageNames.count), height: view.bounds.height/2)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // Add images to the scroll view
        for (index, name) in imageNames.enumerated() {
            let image = UIImage(named: name)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width/2, height: view.bounds.height/2)
            scrollView.addSubview(imageView)
            
            // Add the image view to our array for later use
            images.append(imageView)
        }
    }
}







//
//  ScrollViewController.swift
//  SearchPlaces
//
//  Created by Anup Kuriakose on 23/7/2023.
//

//import UIKit
//
//class ScrollViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
